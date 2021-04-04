INSERT INTO Location (Region, City, Area)
SELECT DISTINCT       TerName,       AreaName,       RegName       FROM zno
UNION SELECT DISTINCT EOTerName,     EOAreaName,     EORegName     FROM zno
UNION SELECT DISTINCT ukrPTTerName,  ukrPTAreaName,  ukrPTRegName  FROM zno
UNION SELECT DISTINCT mathPTTerName, mathPTAreaName, mathPTRegName FROM zno
UNION SELECT DISTINCT histPTTerName, histPTAreaName, histPTRegName FROM zno
UNION SELECT DISTINCT physPTTerName, physPTAreaName, physPTRegName FROM zno
UNION SELECT DISTINCT chemPTTerName, chemPTAreaName, chemPTRegName FROM zno
UNION SELECT DISTINCT bioPTTerName,  bioPTAreaName,  bioPTRegName  FROM zno
UNION SELECT DISTINCT geoPTTerName,  geoPTAreaName,  geoPTRegName  FROM zno
UNION SELECT DISTINCT engPTTerName,  engPTAreaName,  engPTRegName  FROM zno
UNION SELECT DISTINCT fraPTTerName,  fraPTAreaName,  fraPTRegName  FROM zno
UNION SELECT DISTINCT deuPTTerName,  deuPTAreaName,  deuPTRegName  FROM zno
UNION SELECT DISTINCT spaPTTerName,  spaPTAreaName,  spaPTRegName  FROM zno;
DELETE FROM Location WHERE Region IS NULL;
UPDATE Location 
SET Type = zno.terTypeName
FROM zno
WHERE zno.TerName  = Location.Region AND
    zno.AreaName   = Location.City AND
    zno.RegName    = Location.Area;


INSERT INTO Institution(EOName, Type, loc_id, Parent)
SELECT DISTINCT ON (InstInfo.InstName)
	InstInfo.InstName,
	zno.EOTypeName,
	Location.loc_id,
	zno.EOParent
FROM (
    select distinct *
    FROM (
        SELECT DISTINCT EOName, EOTerName, EOAreaName, EORegName FROM zno
        UNION SELECT DISTINCT ukrPTName,  ukrPTTerName,  ukrPTAreaName,  ukrPTRegName  FROM zno
        UNION SELECT DISTINCT mathPTName, mathPTTerName, mathPTAreaName, mathPTRegName FROM zno
        UNION SELECT DISTINCT histPTName, histPTTerName, histPTAreaName, histPTRegName FROM zno
        UNION SELECT DISTINCT physPTName, physPTTerName, physPTAreaName, physPTRegName FROM zno
        UNION SELECT DISTINCT chemPTName, chemPTTerName, chemPTAreaName, chemPTRegName FROM zno
        UNION SELECT DISTINCT bioPTName,  bioPTTerName,  bioPTAreaName,  bioPTRegName  FROM zno
        UNION SELECT DISTINCT geoPTName,  geoPTTerName,  geoPTAreaName,  geoPTRegName  FROM zno
        UNION SELECT DISTINCT engPTName,  engPTTerName,  engPTAreaName,  engPTRegName  FROM zno
        UNION SELECT DISTINCT fraPTName,  fraPTTerName,  fraPTAreaName,  fraPTRegName  FROM zno
        UNION SELECT DISTINCT deuPTName,  deuPTTerName,  deuPTAreaName,  deuPTRegName  FROM zno
        UNION SELECT DISTINCT spaPTName,  spaPTTerName,  spaPTAreaName,  spaPTRegName  FROM zno
    ) as kek
) AS InstInfo (InstName, Region, City, Area)
LEFT JOIN zno ON
	InstInfo.InstName = zno.EOName
LEFT JOIN Location ON
	InstInfo.Region = Location.Region AND
	InstInfo.City = Location.City AND
	InstInfo.Area = Location.Area
WHERE InstInfo.InstName IS NOT NULL;


INSERT INTO Registered (OutID, Birth, Sex, loc_id,
    Status, Profile, Language, EOName)
SELECT DISTINCT ON (OutID) OutID, birth, SexTypeName, loc_id, 
    RegTypeName, ClassProfileName, ClassLangName, EOName
FROM zno INNER JOIN Location
ON zno.TerTypeName = Location.Type
    AND zno.TerName = Location.Region
    AND zno.AreaName = Location.City
    AND zno.RegName = Location.Area;


INSERT INTO Results (OutID, Test, Year, Lang, Result,
    DPALevel, Ball100, Ball12, Ball, AdaptScale, TestPoint)
SELECT OutID, ukrTest, Year, NULL, ukrTestStatus, NULL, 
    ukrBall100, ukrBall12, ukrBall, ukrAdaptScale, UkrPTName
FROM zno
WHERE ukrTest IS NOT NULL;


INSERT INTO Results (OutID, Test, Year, Lang, Result,
    DPALevel, Ball100, Ball12, Ball, AdaptScale, TestPoint)
SELECT OutID, histTest, Year, histLang, histTestStatus, NULL, 
    histBall100, histBall12, histBall, NULL, histPTName
FROM zno
WHERE histTest IS NOT NULL;


INSERT INTO Results (OutID, Test, Year, Lang, Result,
    DPALevel, Ball100, Ball12, Ball, AdaptScale, TestPoint)
SELECT OutID, mathTest, Year, mathLang, mathTestStatus, NULL, 
    mathBall100, mathBall12, mathBall, NULL, mathPTName
FROM zno
WHERE mathTest IS NOT NULL;


INSERT INTO Results (OutID, Test, Year, Lang, Result,
    DPALevel, Ball100, Ball12, Ball, AdaptScale, TestPoint)
SELECT OutID, physTest, Year, physLang, physTestStatus, NULL, 
    physBall100, physBall12, physBall, NULL, physPTName
FROM zno
WHERE physTest IS NOT NULL;


INSERT INTO Results (OutID, Test, Year, Lang, Result,
    DPALevel, Ball100, Ball12, Ball, AdaptScale, TestPoint)
SELECT OutID, chemTest, Year, chemLang, chemTestStatus, NULL, 
    chemBall100, chemBall12, chemBall, NULL, chemPTName
FROM zno
WHERE chemTest IS NOT NULL;


INSERT INTO Results (OutID, Test, Year, Lang, Result,
    DPALevel, Ball100, Ball12, Ball, AdaptScale, TestPoint)
SELECT OutID, bioTest, Year, bioLang, bioTestStatus, NULL, 
    bioBall100, bioBall12, bioBall, NULL, bioPTName
FROM zno
WHERE bioTest IS NOT NULL;


INSERT INTO Results (OutID, Test, Year, Lang, Result,
    DPALevel, Ball100, Ball12, Ball, AdaptScale, TestPoint)
SELECT OutID, geoTest, Year, geoLang, geoTestStatus, NULL, 
    geoBall100, geoBall12, geoBall, NULL, geoPTName
FROM zno
WHERE geoTest IS NOT NULL;


INSERT INTO Results (OutID, Test, Year, Lang, Result,
    DPALevel, Ball100, Ball12, Ball, AdaptScale, TestPoint)
SELECT OutID, engTest, Year, NULL, engTestStatus, engDPALevel, 
    engBall100, engBall12, engBall, NULL, engPTName
FROM zno
WHERE engTest IS NOT NULL;


INSERT INTO Results (OutID, Test, Year, Lang, Result,
    DPALevel, Ball100, Ball12, Ball, AdaptScale, TestPoint)
SELECT OutID, fraTest, Year, NULL, fraTestStatus, fraDPALevel, 
    fraBall100, fraBall12, fraBall, NULL, fraPTName
FROM zno
WHERE fraTest IS NOT NULL;


INSERT INTO Results (OutID, Test, Year, Lang, Result,
    DPALevel, Ball100, Ball12, Ball, AdaptScale, TestPoint)
SELECT OutID, deuTest, Year, NULL, deuTestStatus, deuDPALevel, 
    deuBall100, deuBall12, deuBall, NULL, deuPTName
FROM zno
WHERE deuTest IS NOT NULL;


INSERT INTO Results (OutID, Test, Year, Lang, Result,
    DPALevel, Ball100, Ball12, Ball, AdaptScale, TestPoint)
SELECT OutID, spaTest, Year, NULL, spaTestStatus, spaDPALevel, 
    spaBall100, spaBall12, spaBall, NULL, spaPTName
FROM zno
WHERE spaTest IS NOT NULL;
