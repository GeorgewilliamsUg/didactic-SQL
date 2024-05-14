/*  Poppulate Property Address data */

SELECT *
FROM Sql_Projects.dbo.Nasv

UPDATE Sql_Projects.dbo.Nasv 
SET SaleDate =  CONVERT(Date, SaleDate)

ALTER TABLE Sql_Projects.dbo.Nasv
Add SaleDateConverted Date;


Update Sql_Projects.dbo.Nasv 
SET SaleDateConverted =  CONVERT(Date, SaleDate)

SELECT * 
FROM Sql_Projects.dbo.Nasv AS a
WHERE a.PropertyAddress IS NULL
ORDER BY a.ParcelID DESC;

/*  Poppulate Property Address data */

 SELECT a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress, b.PropertyAddress)
 FROM Sql_Projects.dbo.Nasv a
 JOIN Sql_Projects.dbo.Nasv b
	on a.ParcelID = b.ParcelID
	AND a.[UniqueID ]<> b.[UniqueID ]
WHERE a.PropertyAddress is null

UPDATE a
SET PropertyAddress = ISNULL(a.PropertyAddress, b.PropertyAddress)
FROM Sql_Projects.dbo.Nasv a
 JOIN Sql_Projects.dbo.Nasv b
	on a.ParcelID = b.ParcelID
	AND a.[UniqueID ]<> b.[UniqueID ]
WHERE a.PropertyAddress is null

SELECT PropertyAddress
FROM Sql_Projects.dbo.Nasv

--Using the Long Method  --calling SUBSTRING FUNCTION

SELECT 
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1) as Address,
	SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) +1, LEN(PropertyAddress)) as Address
FROM Sql_Projects.dbo.Nasv

ALTER TABLE Sql_Projects.dbo.Nasv
Add PropertySplitAddress Nvarchar(255);

UPDATE Sql_Projects.dbo.Nasv
SET PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1)

ALTER TABLE Sql_Projects.dbo.Nasv
Add PropertySplitCity Nvarchar(255);

UPDATE Sql_Projects.dbo.Nasv
SET PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) +1, LEN(PropertyAddress))

SELECT *
FROM Sql_Projects.dbo.Nasv

--Using the PARSENAME Method.

SELECT 
    PARSENAME(REPLACE(PropertyAddress, ',', '.'), 2) AS Address,
    PARSENAME(REPLACE(PropertyAddress, ',', '.'), 1) AS City
FROM Sql_Projects.dbo.Nasv;


--Change Y an N TO Yes and 

SELECT Distinct(SoldAsVacant), COUNT(SoldAsVacant)
From Sql_Projects.dbo.Nasv
Group by SoldAsVacant
Order by 2

-- Query to retrieve rows where SoldAsVacant is either 'N' or 'Y'

-- Slecting columns that have Y and N AD Yes and No

SELECT SoldAsVacant
FROM Sql_Projects.dbo.Nasv
WHERE SoldAsVacant IN ('No', 'Yes');


UPDATE Sql_Projects.dbo.Nasv
 SET SoldAsVacant = CASE When SoldAsVacant = 'Y' THEN 'Yes'
	   When SoldAsVacant= 'N' THEN 'No'
	   ELSE SoldAsVacant
	   END
 -- Viewing Changes

 SELECT *
 FROM Sql_Projects.dbo.Nasv

-- Removing Duplicates

SELECT *
FROM Sql_Projects.dbo.Nasv

WITH RowNumCTE AS(
	SELECT *,
		ROW_NUMBER() OVER(
		PARTITION BY ParcelID,
					 PropertyAddress,
					 SalePrice,
					 SaleDate,
					 LegalReference
					 ORDER BY
						UniqueID
						) row_num

FROM Sql_Projects.dbo.Nasv
)

SELECT *
FROM RowNumCTE
WHERE row_num > 1
ORDER BY SalePrice DESC

SELECT *
FROM RowNumCTE
WHERE	row_num > 1
ORDER BY PropertyAddress

SELECT *
FROM Sql_Projects.dbo.Nasv