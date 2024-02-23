/*
Cleaning Data In SQL Queries
*/

SELECT * FROM..NashvilleHousing

--Standardize Date Fromat

SELECT SaleDate, CONVERT(Date,SaleDate)
FROM..NashvilleHousing

UPDATE..NashvilleHousing
SET SaleDate = CONVERT(DATE,SaleDate)

SELECT SaleDate, CONVERT(Date,SaleDate)
FROM..NashvilleHousing

ALTER TABLE..NashvilleHousing
ADD SaledDateConverted Date;

UPDATE NashvilleHousing
SET SaledateConverted = CONVERT(Date,SaleDate)

SELECT SaledateConverted, CONVERT(Date,SaleDate)
FROM..NashvilleHousing

--Populate Property Address Data

SELECT PropertyAddress
FROM..NashvilleHousing
WHERE PropertyAddress is null

SELECT *
FROM..NashvilleHousing
ORDER BY ParcelID

SELECT a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress ISNULL(a.propertyaddress, b.PropertyAddress)
FROM..NashvilleHousing a
JOIN..NashvilleHousing b
	ON a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
WHERE a.PropertyAddress is null

---Breaking Address into individual columns
SELECT propertyAddress
FROM..NashvilleHousing

SELECT 
SUBSTRING(PropertyAddress, 1, CHARINDEX(',',PropertyAddress)) as Address,
	CHARINDEX(',',PropertyAddress)
FROM..NashvilleHousing

SELECT 
SUBSTRING(PropertyAddress, 1, CHARINDEX(',',PropertyAddress) -1) as Address
, SUBSTRING(PropertyAddress, 1, CHARINDEX(',',PropertyAddress) + 1, LEN(ProperyAddress)) as Address
FROM..NashvilleHousing

ALTER TABLE..NashvilleHousing
ADD PropertySplitAddress Nvarchar (255);

UPDATE NashvilleHousing
SET PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',',PropertyAddress) -1)

ALTER TABLE..NashvilleHousing
ADD PropertySplitCity Nvarchar (255);

UPDATE NashvilleHousing
SET PropertySplitCity = SUBSTRING(PropertyAddress, 1, CHARINDEX(',',PropertyAddress) + 1, LEN(ProperyAddress))

SELECT * FROM..NashvilleHousing

SELECT OwnerAddress
FROM..NashvilleHousing

SELECT
PARSENAME(REPLACE(OwnerAddress, ',', '.'), 3),
PARSENAME(REPLACE(OwnerAddress, ',', '.'), 2),
PARSENAME(REPLACE(OwnerAddress, ',', '.'), 1)
FROM..NashvilleHousing

ALTER TABLE..NashvilleHousing
ADD OwnerSplitAddress Nvarchar (255);

UPDATE NashvilleHousing
SET OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 3)

ALTER TABLE..NashvilleHousing
ADD OwnerSplitCity Nvarchar (255);

UPDATE NashvilleHousing
SET OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 2)

ALTER TABLE NashvilleHousing
Add OwnerSplitState Nvarchar(255);

Update NashvilleHousing
SET OwnerSplitState = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 1)

SELECT * FROM..NashvilleHousing

--Change Y and N to Yes and No in "Sold as Vacant" field

SELECT Distinct(SoldAsVacant), COUNT(SoldAsVacant)
FROM..NashvilleHousing
GROUP BY SoldAsVacant
Order by 2

SELECT SoldAsVacant
, CASE WHEN SoldAsVacant = 'Y' THEN 'Yes'
	   WHEN SoldAsVacant = 'N' THEN 'No'
	   ELSE SoldAsVacant
	   END
FROM..NashvilleHousing

UPDATE NashvilleHousing
SET SoldAsVacant = CASE WHEN SoldAsVacant = 'Y' THEN 'Yes'
	   WHEN SoldAsVacant = 'N' THEN 'No'
	   ELSE SoldAsVacant
	   END
FROM..NashvilleHousing


SELECT Distinct(SoldAsVacant), COUNT(SoldAsVacant)
FROM..NashvilleHousing
GROUP BY SoldAsVacant
Order by 2

--REMOVE DUPLICATES
SELECT *,
	ROW_NUMBER() OVER (
	PARTITION BY ParcelID,
		PropertyAddress,
		SalePrice,
		SaleDate,
		LegalReference
		ORDER BY 
			Uniqueid
			)Row_num


FROM..NashvilleHousing 
ORDER BY ParcelID

SELECT *
FROM..NashvilleHousing 

WITH RowNumCTE AS(
SELECT *,
	ROW_NUMBER() OVER (
	PARTITION BY ParcelID,
		PropertyAddress,
		SalePrice,
		SaleDate,
		LegalReference
		ORDER BY 
			Uniqueid
			)row_num

FROM..NashvilleHousing
)
SELECT *
FROM RowNumCTE
WHERE row_num > 1
ORDER BY PropertyAddress

WITH RowNumCTE AS(
SELECT *,
	ROW_NUMBER() OVER (
	PARTITION BY ParcelID,
		PropertyAddress,
		SalePrice,
		SaleDate,
		LegalReference
		ORDER BY 
			Uniqueid
			)row_num

FROM..NashvilleHousing
)
SELECT *
FROM RowNumCTE
WHERE row_num > 1
ORDER BY PropertyAddress


--ORDER BY PropertyAddress

--REMOVE 