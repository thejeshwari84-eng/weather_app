class City {
  bool isSelected;
  final String city;
  final String country;
  final  bool isdefault;
  

  City( {required this.isSelected, required this.city, required this.country, required this.isdefault });
  static List<City>citiesList = [
City(isSelected: false,
 city: 'London', 
country: 'United kingdom', 
isdefault: false),
City(isSelected: false,
 city: 'Tokyo', 
 country: 'Japan',
  isdefault: false),
  City(isSelected: false, 
  city: 'Delhi', 
  country: 'India',
   isdefault: false),
   City(isSelected: false,
    city: 'Beijing',
     country: 'China',
      isdefault: false),
      City(isSelected: false, 
      city: 'Paris',
       country: 'Paris', 
       isdefault: false),
       City(isSelected: false,
        city: 'Rome',
       country: 'Italy',
        isdefault: false),
        City(isSelected: false, 
        city: 'Lagos', 
        country: 'Nigeria', 
        isdefault: false),
        City(isSelected: false,
         city: 'Amsterdam', 
         country: 'Netherlands', 
        isdefault: false),
        City(isSelected: false,
         city: 'Barcelona', 
         country: 'Spain',
         isdefault: false),
        City(isSelected: false,
         city: 'Miani',
          country: 'United states',
           isdefault: false),
        City(
          isSelected: false,
         city: 'Vienna', 
         country: 'Austria', 
         isdefault: false),
         City(
          isSelected: 
         false, 
         city: 'Berlin', 
         country: 'Germany', isdefault: false),
         City(
          isSelected: false, 
         city: 'Tornoto', 
         country: 'canada',
         isdefault: false),
         City(
          isSelected: false, 
         city: 'Brussels', 
         country: 'Belgium',
          isdefault: false),
          City(
          isSelected: false, 
          city: 'Nairobi',
           country: 'Kenya', 
          isdefault: false),
  ];
          //get the selected cities
      static List<City> getSelectedCities(){
        List<City> selectedcities = City.citiesList;
        return selectedcities
        .where((city) => city.isSelected==true )
        .toList();
      }
 
}