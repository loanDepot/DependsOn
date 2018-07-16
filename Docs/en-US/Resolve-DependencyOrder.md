---
external help file: DependsOn-help.xml
Module Name: DependsOn
online version:
schema: 2.0.0
---

# Resolve-DependencyOrder

## SYNOPSIS

## SYNTAX

```
Resolve-DependencyOrder [-InputObject] <PSObject[]> [[-Key] <ScriptBlock>] [-DependsOn] <ScriptBlock>
 [<CommonParameters>]
```

## DESCRIPTION
Takes a list of objects that depend on each other and orders them.

## EXAMPLES

### EXAMPLE 1
```
Resolve-DependencyOrder -InputObject @(
```

@{Name='Girl';DependsOn='Dad','Mom'}
    @{Name='Mom';DependsOn='Dad'}
    @{Name='Dad';DependsOn='Grandpa','Grandma'}
    @{Name='Grandpa';DependsOn=$null}
    @{Name='Grandma';DependsOn='Grandpa'}
    @{Name='Boy';DependsOn='Dad','Mom'}
) -Key {$_.name} -DependsOn {$_.DependsOn}

Takes a collection of hashtables and orders them so the dependant object come first.

### EXAMPLE 2
```
$map = [ordered]@{
```

'Girl'='Dad','Mom'
    'Mom'='Dad'
    'Grandpa' = $null
    'Dad'='Grandpa','Grandma'
    'Grandma'='Grandpa'
    'Boy'='Dad','Mom'
}

Resolve-DependencyOrder -InputObject $map.Keys -DependsOn {$map\[$_\]}

Uses an external source for the mapping of strings.

## PARAMETERS

### -DependsOn
{{Fill DependsOn Description}}

```yaml
Type: ScriptBlock
Parameter Sets: (All)
Aliases:

Required: True
Position: 3
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -InputObject
{{Fill InputObject Description}}

```yaml
Type: PSObject[]
Parameter Sets: (All)
Aliases:

Required: True
Position: 1
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### -Key
{{Fill Key Description}}

```yaml
Type: ScriptBlock
Parameter Sets: (All)
Aliases:

Required: False
Position: 2
Default value: {"$PSItem"}
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see about_CommonParameters (http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES
An exception will be thrown if there are duplicate keys
Circular dependancies are only walked once and then ignored without warning
If a key is not provided, the tostring() of the object is used
Each object will only show up once in the output
The DependsOn can be an array of strings
Order of objects is preserved until a DependsOn is identified
Dependencies will be walked in order that they are defined in the DependsOn

## RELATED LINKS
