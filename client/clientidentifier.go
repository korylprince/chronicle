package main

import (
	"fmt"
	"os"

	"github.com/DHowett/go-plist"
)

const plistPath = "/Library/Preferences/ManagedInstalls.plist"

//GetClientIdentifier retreives the munki ClientIdentifier key
func GetClientIdentifier() (identifer string, err error) {

	f, err := os.Open(plistPath)
	if err != nil {
		return "", err
	}
	defer f.Close()

	var config map[string]interface{}

	d := plist.NewDecoder(f)
	err = d.Decode(&config)
	if err != nil {
		return "", err
	}

	identifier, ok := config["ClientIdentifier"]
	if !ok {
		return "", fmt.Errorf("ClientIdentifier is not a valid key")
	}

	i, ok := identifier.(string)
	if !ok {
		return "", fmt.Errorf("ClientIdentifier is not a valid string")
	}

	return i, nil
}
