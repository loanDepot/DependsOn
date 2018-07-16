
function Resolve-DependencyOrder
{
    <#
        .DESCRIPTION
        Takes a list of objects that depend on each other and orders them.

        .Example
        
        Resolve-DependencyOrder -InputObject @(
            @{Name='Girl';DependsOn='Dad','Mom'}
            @{Name='Mom';DependsOn='Dad'}
            @{Name='Dad';DependsOn='Grandpa','Grandma'}
            @{Name='Grandpa';DependsOn=$null}
            @{Name='Grandma';DependsOn='Grandpa'}
            @{Name='Boy';DependsOn='Dad','Mom'}
        ) -Key {$_.name} -DependsOn {$_.DependsOn}

        Takes a collection of hashtables and orders them so the dependant object come first.

        .EXAMPLE
                
        $map = [ordered]@{
            'Girl'='Dad','Mom'
            'Mom'='Dad'
            'Grandpa' = $null
            'Dad'='Grandpa','Grandma'
            'Grandma'='Grandpa'
            'Boy'='Dad','Mom'
        }

        Resolve-DependencyOrder -InputObject $map.Keys -DependsOn {$map[$_]}

        Uses an external source for the mapping of strings.

        .NOTES
        An exception will be thrown if there are duplicate keys
        Circular dependancies are only walked once and then ignored without warning
        If a key is not provided, the tostring() of the object is used
        Each object will only show up once in the output
        The DependsOn can be an array of strings
        Order of objects is preserved until a DependsOn is identified
        Dependencies will be walked in order that they are defined in the DependsOn

    #>
    [cmdletbinding()]
    param(
        [parameter(
            Mandatory,
            Position = 0,
            ValueFromPipeline
        )]
        [ValidateNotNullOrEmpty()]
        [PSObject[]]
        $InputObject,

        [parameter(
            Position = 1,
            ValueFromPipelineByPropertyName
        )]
        [scriptblock]$Key = {"$PSItem"},

        [parameter(
            Mandatory,
            Position = 2,
            ValueFromPipelineByPropertyName
        )]
        [scriptblock]$DependsOn
    )

    begin
    {
        # using an uncommon name to avoid collisions
        ${*map} = [DependsOn.DependencyMap]::new()
    }

    process
    {
        foreach ($node in $InputObject)
        {
            $dependsOnValue = $node | ForEach-Object $DependsOn
            $keyValue = $node | ForEach-Object $Key
            ${*map}.Add($node, $keyValue, $dependsOnValue)
        }
    }

    end
    {
        ${*map}.ToArray()
    }
}
