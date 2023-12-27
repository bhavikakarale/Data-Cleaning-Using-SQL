select * from DataAnalysisUsingSQL.dbo.NashvilleHousing

select SaleDate, convert  (date, SaleDate)
from DataAnalysisUsingSQL.dbo.NashvilleHousing


alter table NashvilleHousing
add SaleDateConverted Date;
Update NashvilleHousing
set SaleDateConverted = Convert(Date, SaleDate)

select SaleDateConverted from NashvilleHousing



--Populate address property data

select *
from DataAnalysisUsingSQL.dbo.NashvilleHousing
where PropertyAddress is null
order by ParcelID

select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, isnull(a.PropertyAddress, b.PropertyAddress)
from DataAnalysisUsingSQL.dbo.NashvilleHousing a
join DataAnalysisUsingSQL.dbo.NashvilleHousing b
on a.ParcelID = b.ParcelID
and a.[UniqueID ] <> b.[UniqueID ]
where a.PropertyAddress is null

update a
set PropertyAddress = isnull(a.PropertyAddress, b.PropertyAddress)
from DataAnalysisUsingSQL.dbo.NashvilleHousing a
join DataAnalysisUsingSQL.dbo.NashvilleHousing b
on a.ParcelID = b.ParcelID
and a.[UniqueID ] <> b.[UniqueID ]
where a.PropertyAddress is null


--break address into address, city, state

--split property address into house address and city
--first check if query is running without actual updating the table
select PropertyAddress
from DataAnalysisUsingSQL.dbo.NashvilleHousing

select SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1) as Address,
 SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) +1, len(PropertyAddress)) as Address
From DataAnalysisUsingSQL.dbo.NashvilleHousing


--update the tab;e now that the query gives expected result
alter table DataAnalysisUsingSQL.dbo.NashvilleHousing
add PropertySplitAddress nvarchar(255);
Update DataAnalysisUsingSQL.dbo.NashvilleHousing
set PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1) 
select PropertySplitAddress from DataAnalysisUsingSQL.dbo.NashvilleHousing

alter table DataAnalysisUsingSQL.dbo.NashvilleHousing
add PropertySplitCity nvarchar(255);
Update DataAnalysisUsingSQL.dbo.NashvilleHousing
set PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) +1, len(PropertyAddress))
select PropertySplitCity from DataAnalysisUsingSQL.dbo.NashvilleHousing


select * from DataAnalysisUsingSQL.dbo.NashvilleHousing

select OwnerAddress from DataAnalysisUsingSQL.dbo.NashvilleHousing


--select SUBSTRING(OwnerAddress, 1, CHARINDEX(',', OwnerAddress)-1) as ownera
--from DataAnalysisUsingSQL.dbo.NashvilleHousing

--split owner addresss into house address, city, state
alter table DataAnalysisUsingSQL.dbo.NashvilleHousing
add OwnerAddressSplit nvarchar(255)
Update DataAnalysisUsingSQL.dbo.NashvilleHousing
set OwnerAddressSplit = SUBSTRING(OwnerAddress, 1, CHARINDEX(',', OwnerAddress)-1) 
select OwnerAddressSplit from DataAnalysisUsingSQL.dbo.NashvilleHousing

alter table DataAnalysisUsingSQL.dbo.NashvilleHousing
add OwnerAddressCity nvarchar(255)
update DataAnalysisUsingSQL.dbo.NashvilleHousing
set OwnerAddressCity = PARSENAME(replace(OwnerAddress,',','.') ,2)



alter table DataAnalysisUsingSQL.dbo.NashvilleHousing
add OwnerAddressState nvarchar(255)
update DataAnalysisUsingSQL.dbo.NashvilleHousing
set OwnerAddressState = PARSENAME(replace(OwnerAddress, ',','.'), 1)



select * from DataAnalysisUsingSQL.dbo.NashvilleHousing



--Change Y and N to Yes and No in "Sold as Vacant"
select distinct(SoldAsVacant), count(SoldAsVacant)
from DataAnalysisUsingSQL.dbo.NashvilleHousing
group by SoldAsVacant

select SoldAsVacant
, case when SoldAsVacant = 'Y' then 'Yes'
	   when SoldAsVacant = 'N' then 'No'
	   Else SoldAsVacant
	   end
from DataAnalysisUsingSQL.dbo.NashvilleHousing

update DataAnalysisUsingSQL.dbo.NashvilleHousing
set SoldAsVacant = case when SoldAsVacant = 'Y' then 'Yes'
	   when SoldAsVacant = 'N' then 'No'
	   Else SoldAsVacant
	   end
from DataAnalysisUsingSQL.dbo.NashvilleHousing


--remove duplicates

with RowNumCTE as(
select * ,
row_number() over (
partition by ParcelID, PropertyAddress, SalePrice, SaleDate, LegalReference
order by UniqueID
) row_num
from DataAnalysisUsingSQL.dbo.NashvilleHousing
)
delete from RowNumCTE
where row_num >1 
-- order by PropertyAddress


--delete unused columns

select * from DataAnalysisUsingSQL.dbo.NashvilleHousing

alter table DataAnalysisUsingSQL.dbo.NashvilleHousing
drop column OwnerAddress, TaxDistrict, PropertyAddress

alter table DataAnalysisUsingSQL.dbo.NashvilleHousing
drop column SaleDate