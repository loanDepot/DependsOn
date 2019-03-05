Describe "function Resolve-DependencyOrder" -Tag Build {

    it "handles hashtables" {
        $results = Resolve-DependencyOrder -InputObject @(
            @{Name = 'Girl';    DependsOn = 'Dad', 'Mom'}
            @{Name = 'Mom';     DependsOn = 'Dad'}
            @{Name = 'Dad';     DependsOn = 'Grandpa', 'Grandma'}
            @{Name = 'Grandpa'; DependsOn = $null}
            @{Name = 'Grandma'; DependsOn = 'Grandpa'}
            @{Name = 'Boy';     DependsOn = 'Dad', 'Mom'}
        ) -Key {$_.name} -DependsOn {$_.DependsOn}

        $results | Should -Not -BeNullOrEmpty
        $results | Should -HaveCount 6
        $results[0].Name | Should -BeExactly 'Grandpa'
        $results[-1].Name | Should -BeExactly 'Boy'
    }

    it "handles objects" {
        $results = Resolve-DependencyOrder -InputObject @(
            [pscustomobject]@{Name = 'Girl';    DependsOn = 'Dad', 'Mom'}
            [pscustomobject]@{Name = 'Mom';     DependsOn = 'Dad'}
            [pscustomobject]@{Name = 'Dad';     DependsOn = 'Grandpa', 'Grandma'}
            [pscustomobject]@{Name = 'Grandpa'; DependsOn = $null}
            [pscustomobject]@{Name = 'Grandma'; DependsOn = 'Grandpa'}
            [pscustomobject]@{Name = 'Boy';     DependsOn = 'Dad', 'Mom'}
        ) -Key {$_.name} -DependsOn {$_.DependsOn}

        $results | Should -Not -BeNullOrEmpty
        $results | Should -HaveCount 6
        $results[0].Name | Should -BeExactly 'Grandpa'
        $results[-1].Name | Should -BeExactly 'Boy'
    }

    it "can use strings with a external lookup tables" {

        $map = [ordered]@{
            'Girl'    = 'Dad', 'Mom'
            'Mom'     = 'Dad'
            'Grandpa' = $null
            'Dad'     = 'Grandpa', 'Grandma'
            'Grandma' = 'Grandpa'
            'Boy'     = 'Dad', 'Mom'
        }

        $results = Resolve-DependencyOrder -InputObject $map.Keys -DependsOn {$map[$_]}
        $results | Should -Not -BeNullOrEmpty
        $results | Should -HaveCount 6
        $results[0] | Should -BeExactly 'Grandpa'
        $results[-1] | Should -BeExactly 'Boy'
    }

    it "handles circular lookups without errors" {
        $results = Resolve-DependencyOrder -InputObject @(
            [pscustomobject]@{Name = 'Mom'; DependsOn = 'Dad'}
            [pscustomobject]@{Name = 'Dad'; DependsOn = 'Mom'}
        ) -Key {$_.name} -DependsOn {$_.DependsOn}

        $results | Should -Not -BeNullOrEmpty
        $results | Should -HaveCount 2
        $results[0].Name | Should -BeExactly 'Dad'
        $results[-1].Name | Should -BeExactly 'Mom'
    }

    it "handles self-lookups without errors" {
        $results = Resolve-DependencyOrder -InputObject @(
            [pscustomobject]@{Name = 'Mom'; DependsOn = 'Mom'}
            [pscustomobject]@{Name = 'Dad'; DependsOn = 'Dad'}
        ) -Key {$_.name} -DependsOn {$_.DependsOn}

        $results | Should -Not -BeNullOrEmpty
        $results | Should -HaveCount 2
        $results[0].Name | Should -BeExactly 'Mom'
        $results[-1].Name | Should -BeExactly 'Dad'
    }

    It "Handles null items in a list" {
        $list = @(1, 2, $null, , 3)
        $results = Resolve-DependencyOrder -InputObject $list -Key {$_} -DependsOn {$null}
    }

    It "Handles null items in a list over the pipe" {
        $list = @(1, 2, $null, , 3)
        $results = $list | Resolve-DependencyOrder -Key {$_} -DependsOn {$null}
    }
}
