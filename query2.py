import psycopg2
import csv


conn = psycopg2.connect(dbname='postgres', user='postgres', password='postgres', host='localhost', port="5432")
cursor = conn.cursor()


query = '''
SELECT Location.Area, Results.year, min(Results.Ball100)
FROM migration.Results JOIN migration.Registered ON
    Results.OutID = Registered.OutID
JOIN migration.Location ON
    Registered.loc_id = Location.loc_id
WHERE Results.Test = 'Історія України' AND
    Results.Result = 'Зараховано'
GROUP BY Location.Area, Results.year
'''
cursor.execute(query)


with open('result2.csv', 'w', encoding="utf-8") as f:
    writer = csv.writer(f, lineterminator="\n")
    writer.writerow(['Область', 'Рік', 'Найгірший бал з Історії України'])
    for row in cursor:
        writer.writerow(row)


cursor.close()
conn.close()
