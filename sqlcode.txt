SELECT

    SERVERPROPERTY('ServerName') AS [ServerName]

    ,SERVERPROPERTY('ComputerNamePhysicalNetBIOS') AS [ComputerNamePhysicalNetBIOS]

    ,SERVERPROPERTY('InstanceName') AS [Instance]

    ,SERVERPROPERTY('MachineName') AS [MachineName]

    ,@@VERSION AS [Version]

    ,SERVERPROPERTY('BuildClrVersion') AS BuildClrVersion

    ,SERVERPROPERTY('Edition') AS [Edition]

    ,SERVERPROPERTY('ProductBuild') AS ProductBuild

    ,SERVERPROPERTY('ProductBuildType') AS ProductBuildType

    ,SERVERPROPERTY('ProductLevel') AS ProductLevel

    ,SERVERPROPERTY('ProductMajorVersion') AS ProductMajorVersion

    ,SERVERPROPERTY('ProductMinorVersion') AS ProductMinorVersion

    ,SERVERPROPERTY('ProductUpdateLevel') AS ProductUpdateLevel

    ,SERVERPROPERTY('ProductUpdateReference') AS ProductUpdateReference

    ,SERVERPROPERTY('ProductVersion') AS [ProductVersion]

    ,SERVERPROPERTY('ResourceLastUpdateDateTime') AS ResourceLastUpdateDateTime

    ,SERVERPROPERTY('ResourceVersion') AS ResourceVersion