--cleaning data in SQL

select *
from portfolioProject.dbo.nashvillehousing

--changing date and time to just date fromat

select SaleDateConverted, convert(date,saledate) as date
from portfolioProject.dbo.nashvillehousing

alter table nashVilleHousing
add SaleDateConverted date;

update nashVillehousing
set SaleDateConverted=CONVERT(date,saledate)
							
										

--populateproperty address data

select *
from portfolioProject.dbo.nashvillehousing
where PropertyAddress is null



select  a.parcelid,a.propertyaddress,b.parcelid,b.propertyaddress,ISNULL(a.propertyaddress,b.propertyaddress)
from portfolioProject.dbo.nashvillehousing a
join portfolioProject.dbo.nashvillehousing b
on a.parcelid=b.parcelid
and a.uniqueid <> b.uniqueid
where a.propertyaddress is null

update A
set propertyaddress=ISNULL(a.propertyaddress,b.propertyaddress)
from portfolioProject.dbo.nashvillehousing a
join portfolioProject.dbo.nashvillehousing b
on a.parcelid=b.parcelid
and a.[uniqueid] <> b.[uniqueid]
where a.propertyaddress is null


										--beaking out address into individual columm
select
SUBSTRING(propertyaddress,1,charindex(',',propertyaddress)-1) as address,
SUBSTRING(propertyaddress,CHARINDEX(',',propertyaddress)+1,len(propertyaddress)) as city
from portfolioProject.dbo.nashvillehousing


alter table nashVilleHousing
add propertysplitaddress nvarchar(255)

update nashvillehousing
set propertysplitaddress=SUBSTRING(propertyaddress,1,charindex(',',propertyaddress)-1)

alter table nashVilleHousing
add city nvarchar(255)

update nashvillehousing
set city=SUBSTRING(propertyaddress,CHARINDEX(',',propertyaddress)+1,len(propertyaddress))


select
PARSENAME(replace(owneraddress,',','.'),3),
PARSENAME(replace(owneraddress,',','.'),2),
PARSENAME(replace(owneraddress,',','.'),1)
from portfolioProject.dbo.nashvillehousing


alter table nashVilleHousing
add owneraplitaddress nvarchar(255)
update nashvillehousing
set owneraplitaddress=PARSENAME(replace(owneraddress,',','.'),3)

alter table nashVilleHousing
add owneraplitaddress nvarchar(255)
update nashvillehousing
set   owneraplitaddress=PARSENAME(replace(owneraddress,',','.'),2)


alter table nashVilleHousing
add ownersplitstate nvarchar(255)
update nashvillehousing
set  ownersplitstate=PARSENAME(replace(owneraddress,',','.'),1)


--change y and n to yes and no in 'sold as vacant' field

select distinct(soldasvacant),count(soldasvacant)
from portfolioProject.dbo.nashvillehousing
group by soldasvacant
order by 2


select soldasvacant
, case  when soldasvacant='y' then 'Yes'
		when soldasvacant='N' then 'No'
		else soldasvacant
		END
from portfolioProject.dbo.nashvillehousing


update nashvillehousing
set soldasvacant=case  when soldasvacant='y' then 'Yes'
		when soldasvacant='N' then 'No'
		else soldasvacant
		END


												--removing duplicate

with RowNumCTE as(
select *,
	row_number() over(
		partition by parcelid,
					 PropertyAddress,
					 SalePrice,
					 SaleDate,
					 LegalReference
					 order by UniqueID
					 ) row_num
from portfolioProject.dbo.nashvillehousing
--order by ParcelId
)
select *
from RowNumCTE
where row_num >1


													--delete unused columms
select *
from portfolioProject.dbo.nashvillehousing
  
Alter table portfolioProject.dbo.nashvillehousing
Drop column PropertyAddress,owneraddress,taxdistrict,saledate