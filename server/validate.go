package main

//ValidationError represents a field that is too long
type ValidationError string

func (v ValidationError) Error() string {
	return "Field " + string(v) + " is too long"
}

func checkLength(s string, l int) bool {
	return len(s) <= l
}

//Validate checks that the given Entry's fields fit in the DB
func Validate(e *Entry) error {
	switch {
	case !checkLength(e.Username, 64):
		return ValidationError(e.Username)
	case !checkLength(e.FullName, 128):
		return ValidationError(e.FullName)
	case !checkLength(e.Serial, 32):
		return ValidationError(e.Serial)
	case !checkLength(e.Hostname, 32):
		return ValidationError(e.Hostname)
	case !checkLength(e.IP, 15):
		return ValidationError(e.IP)
	case !checkLength(e.InternetIP, 15):
		return ValidationError(e.InternetIP)
	}
	return nil
}
