let aviate_labs = https://github.com/aviate-labs/package-set/releases/download/v0.1.4/package-set.dhall sha256:30b7e5372284933c7394bad62ad742fec4cb09f605ce3c178d892c25a1a9722e
let vessel_package_set = https://github.com/dfinity/vessel-package-set/releases/download/mo-0.6.20-20220131/package-set.dhall

let Package = { 
	name : Text, 
	version : Text, 
	repo : Text, 
	dependencies : List Text 
}

-- This is where you can add/override existing packages in the package-set
-- For example, if you wanted to use version `v2.0.0` of the foo library:
let additions = [
	{ 
		name = "base", 
		repo = "https://github.com/dfinity/motoko-base", 
		version = "moc-0.7.2", 
		dependencies = [ "base" ]
  	},
	{ 
		name = "MultiValuedMap", 
		version = "main", 
		repo = "https://github.com/NatLabs/MultiValuedMap", 
		dependencies = [ "base" ] : List Text
	},
	{ 
		name = "Itertools", 
		version = "main", 
		repo = "https://github.com/NatLabs/Itertools.mo", 
		dependencies = [ "base" ] : List Text
	}
] : List Package

in  aviate_labs # vessel_package_set # additions
