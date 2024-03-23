package schemas

type UsersFound []struct {
	BusinessPhones    []interface{} `json:"businessPhones"`
	DisplayName       string        `json:"displayName"`
	GivenName         interface{}   `json:"givenName"`
	Id                string        `json:"id"`
	JobTitle          interface{}   `json:"jobTitle"`
	Mail              string        `json:"mail"`
	MobilePhone       interface{}   `json:"mobilePhone"`
	OfficeLocation    interface{}   `json:"officeLocation"`
	PreferredLanguage interface{}   `json:"preferredLanguage"`
	Surname           interface{}   `json:"surname"`
	UserPrincipalName string        `json:"userPrincipalName"`
}
