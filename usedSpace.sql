

select
      name
    , filename
    , convert(decimal(12,2),round(a.size/128.000,2)) as FileSizeMB
    , convert(decimal(12,2),round(fileproperty(a.name,'SpaceUsed')/128.000,2)) as SpaceUsedMB
    , convert(decimal(12,2),round((a.size-fileproperty(a.name,'SpaceUsed'))/128.000,2)) as FreeSpaceMB
from dbo.sysfiles a