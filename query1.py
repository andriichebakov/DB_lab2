import psycopg2
import psycopg2.errorcodes
import csv
import itertools
import datetime


conn = psycopg2.connect(dbname='postgres', user='postgres', password='postgres', host='localhost', port="5432")
cursor = conn.cursor()
cursor.execute('DROP TABLE IF EXISTS zno;')
conn.commit()


def creating():
    with open("Odata2019File.csv", "r", encoding="cp1251") as f:
        title = f.readline().split(';')
        title = [head.strip('"') for head in title]
        title[-1] = title[-1].rstrip('"\n')
        columns = "\n\tYear INT,"
        for head in title:
            if head == 'Birth':
                columns += '\n\t' + head + ' INT,'
            elif 'Ball' in head:
                columns += '\n\t' + head + ' REAL,'
            elif head == "OUTID":
                columns += '\n\t' + head + ' VARCHAR(255) PRIMARY KEY,'
            else:
                columns += '\n\t' + head + ' VARCHAR(255),'
        cursor.execute('''CREATE TABLE IF NOT EXISTS zno (''' + columns.rstrip(',') + '\n);')
        conn.commit()
        return title


title = creating()


def inserting(f, year, conn, cursor, logs):
    begin = datetime.datetime.now()
    with open(f, "r", encoding="cp1251") as file:
        print("Читається " + f + ' ...' )
        csv_reader = csv.DictReader(file, delimiter=';')
        inserted = 0
        size = 100
        inserted_size = False
        while not inserted_size:
            try:
                insert_query = '''INSERT INTO zno (year, ''' + ', '.join(title) + ') VALUES '
                cnt = 0
                for row in csv_reader:
                    cnt += 1
                    for key in row:
                        if row[key] == 'null':
                            pass
                        elif key.lower() != 'birth' and 'ball' not in key.lower():
                            row[key] = "'" + row[key].replace("'", "''") + "'"
                        elif 'ball100' in key.lower():
                            row[key] = row[key].replace(',', '.')
                    insert_query += '\n\t(' + str(year) + ', ' + ','.join(row.values()) + '),'
                    if cnt == size:
                        cnt = 0
                        insert_query = insert_query.rstrip(',') + ';'
                        cursor.execute(insert_query)
                        conn.commit()
                        inserted += 1
                        insert_query = '''INSERT INTO zno (year, ''' + ', '.join(title) + ') VALUES '
                if cnt != 0:
                    insert_query = insert_query.rstrip(',') + ';'
                    cursor.execute(insert_query)
                    conn.commit()
                inserted_size = True
            except psycopg2.OperationalError as error:
                if error.pgcode == psycopg2.errorcodes.ADMIN_SHUTDOWN:
                    print("Падіння бази даних( чекаємо відновлення з'єднання...")
                    logs.write(str(datetime.datetime.now()) + " - з'єднання втрачено\n")
                    connection_restored = False
                    while not connection_restored:
                        try:
                            conn = psycopg2.connect(dbname='postgres', user='postgres', password='postgres', host='localhost', port="5432")
                            cursor = conn.cursor()
                            logs.write(str(datetime.datetime.now()) + " - відновленя з'єднання\n")
                            connection_restored = True
                        except psycopg2.OperationalError:
                            pass

                    print("З'єднання відновлено")
                    file.seek(0,0)
                    csv_reader = itertools.islice(csv.DictReader(file, delimiter=';'), inserted * size, None)

    end = datetime.datetime.now()
    logs.write('Витрачено часу на обробку ' + f + " : " + str(end - begin) + '\n\n')

    return conn, cursor


logs = open('logs.txt', 'w')
conn, cursor = inserting("Odata2019File.csv", 2019, conn, cursor, logs)
conn, cursor = inserting("Odata2020File.csv", 2020, conn, cursor, logs)
logs.close()



query = '''
SELECT regname, year, min(histBall100)
FROM zno
WHERE histTestStatus = 'Зараховано'
GROUP BY regname, year;
'''
cursor.execute(query)

with open('result.csv', 'w', encoding="utf-8") as new_f:
    csv_writer = csv.writer(new_f, lineterminator="\n")
    csv_writer.writerow(['Область', 'Рік', 'Мінімінальний бал з історії України'])
    for row in cursor:
        csv_writer.writerow(row)


cursor.close()
conn.close()
