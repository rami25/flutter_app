import 'package:flutter/material.dart';
import 'package:flutter_application_1/models/category_model.dart';
import 'package:flutter_application_1/models/diet_model.dart';
import 'package:flutter_svg/flutter_svg.dart';

class HomePage extends StatefulWidget {
  HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class Person {
  final String name;
  final String job;

  Person(this.name, this.job);
}

class _HomePageState extends State<HomePage> {
  List<CategoryModel> categories = [];
  List<DietModel> diets = [];

    List<Person> people = [
      Person("Alice", "Engineer"),
      Person("Bob", "Designer"),
      Person("Charlie", "Doctor"),
      Person("David", "Developer"),
      Person("Eva", "Artist"),
  ];
  List<Person> suggestions = [];

  int _currentIndex = 0;
  final FocusNode _searchFocusNode = FocusNode();
  final TextEditingController _searchController = TextEditingController();
  final LayerLink _layerLink = LayerLink();

  void getAll() {
    categories = CategoryModel.getCategories();
    diets = DietModel.getDiets();

  }

  @override
  Widget build(BuildContext context) {
    getAll();
    return Scaffold(
      appBar: appBar(),
  // body: Padding(
  //       padding: const EdgeInsets.all(16.0),
  //       child: Column(
  //         children: [
  //           TextField(
  //             controller: _searchController,
  //             onChanged: _onSearchChanged,
  //             decoration: InputDecoration(
  //               hintText: "Search person...",
  //               border: OutlineInputBorder(),
  //             ),
  //           ),
  //           SizedBox(height: 10),
  //           Expanded(
  //             child: ListView.builder(
  //               itemCount: suggestions.length,
  //               itemBuilder: (context, index) {
  //                 final person = suggestions[index];
  //                 return ListTile(
  //                   title: Text(person.name),
  //                   subtitle: Text(person.job),
  //                   onTap: () {
  //                     // Set text to selected suggestion
  //                     _searchController.text = person.name;
  //                     setState(() {
  //                       suggestions.clear(); // hide list
  //                     });
  //                   },
  //                 );
  //               },
  //             ),
  //           )
  //         ],
  //       ),
  //     ),



      endDrawer: drawerTest(context),
      backgroundColor: Colors.white,
      body : Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // searchField(),
          anathor(),
          SizedBox(height : 40,),
          categoriesSection(),
          // SizedBox(height : 40,),
          // dietSection()
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _onTabTapped,
        selectedItemColor: Colors.orange,
        backgroundColor : const Color.fromARGB(255, 241, 224, 200),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Search',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }

  // search focus
  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });

    if (index == 1) {
      Future.delayed(Duration(milliseconds: 100), () {
        FocusScope.of(context).requestFocus(_searchFocusNode);
      });
    }
  }

  @override
  void dispose() {
    _searchFocusNode.dispose();
    _searchController.dispose();
    super.dispose();
  }
  ///

  void _onSearchChanged(String query) {
    setState(() {
      suggestions = people
          .where((person) =>
              person.name.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }



  Drawer drawerTest(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          Container(
            height: 65,
            child: DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.orange,
              ),
              child: Transform.translate(
                offset: const Offset(0, -7),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Builder(
                    builder: (context) => IconButton(
                      icon: Icon(Icons.arrow_forward),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      // iconSize: 18,
                      color : Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.home),
            title: const Text('Home'),
            onTap: () {
              Navigator.pop(context); // Close drawer
              // Add your navigation logic here
            },
          ),
          ListTile(
            leading: const Icon(Icons.person),
            title: const Text('Profile'),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text('Settings'),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('Logout'),
            onTap: () {
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }

  Column dietSection() {
    return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left : 20),
              child: Text(
                'Recommendation\for Diet',
                style : TextStyle(
                  color : Colors.black,
                  fontSize : 18,
                  fontWeight: FontWeight.w600
                )
              ),
            ),
            SizedBox(height: 15,),
            Container(
              height: 140,
              child : ListView.separated(
                itemCount: diets.length,
                scrollDirection: Axis.horizontal,
                separatorBuilder: (context, index) => SizedBox(width : 25),
                itemBuilder: (context, index) {
                  return Container(
                    width : 220,
                    decoration: BoxDecoration(
                      color : diets[index].boxColor.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(20)
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        SvgPicture.network(diets[index].iconPath),
                        Column(
                          children : [
                              Text(
                                diets[index].name,
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  color : Colors.black,
                                  fontSize : 16
                                )
                              ),
                              Text(
                                diets[index].level + ' | ' + diets[index].duration + ' | ' + diets[index].calorie,
                                style: const TextStyle(
                                  color: Color(0xff7B6F72),
                                  fontSize: 13,
                                  fontWeight: FontWeight.w400
                                ),
                              ),
                          ]
                        ),
                        Container(
                          height: 45,
                          width : 130,
                          child : Center(
                            child : Text(
                              'View',
                              style: TextStyle(
                                color: diets[index].viewIsSelected ? Colors.white : const Color(0xffC58BF2),
                                fontWeight : FontWeight.w600,
                                fontSize : 14
                              ),
                            )
                          ),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors : [
                               diets[index].viewIsSelected ? const Color(0xff9DCEFF) : Colors.transparent,
                               diets[index].viewIsSelected ? const Color(0xff92A3FD) : Colors.transparent                                 
                              ]
                            ),
                            borderRadius: BorderRadius.circular(50)
                          ),
                        )
                      ],
                    ),
                  );
                },
                padding: EdgeInsets.only(left : 20, right : 20),
              )
            )
          ],
        );
  }

  Column categoriesSection() {
    return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left : 20),
              child: Text(
                'Category',
                style : TextStyle(
                  color : Colors.black,
                  fontSize : 18,
                  fontWeight: FontWeight.w600
                )
              ),
            ),
            SizedBox(height : 15),
            Container(
              height : 120,
              child : ListView.separated(
                itemCount: categories.length,
                scrollDirection: Axis.horizontal,
                padding: EdgeInsets.only(left : 20, right : 20),
                separatorBuilder: (context, index) => SizedBox(width : 25),
                itemBuilder: (context, index) {
                  return Container(
                    width: 100,
                    decoration: BoxDecoration(
                      color : categories[index].boxColor.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(16)
                    ),
                    child : Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Container(
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                            color : Colors.white,
                            shape : BoxShape.circle
                          ),
                          child : Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: SvgPicture.network(categories[index].iconPath),
                          )
                        ),
                        Text(
                          categories[index].name,
                          style : TextStyle(
                            fontWeight: FontWeight.w400,
                            color : Colors.black,
                            fontSize : 14
                          )
                          
                        )
                      ],
                    )
                  );
                },
              )
            )
          ],
        );
  }

Stack anathor() {
  return Stack(
  children: [
    // Main layout under the floating suggestion box
    Column(
      children: [
        // 🔗 Attach anchor for the suggestion box
        CompositedTransformTarget(
          link: _layerLink,
          child: Container(
            margin: EdgeInsets.only(top: 40, left: 20, right: 20),
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: const Color.fromARGB(255, 183, 190, 194),
                  blurRadius: 40,
                  spreadRadius: 0.0,
                )
              ],
            ),
            child: TextField(
              focusNode: _searchFocusNode,
              controller: _searchController,
              onChanged: _onSearchChanged,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                contentPadding: EdgeInsets.all(15),
                hintText: 'Search',
                hintStyle: TextStyle(
                  color: const Color.fromARGB(255, 81, 79, 79),
                  fontSize: 14,
                ),
                prefixIcon: Padding(
                  padding: const EdgeInsets.all(12),
                  child: SvgPicture.network('assets/icons/search.svg'),
                ),
                suffixIcon: Container(
                  width: 100,
                  child: IntrinsicHeight(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        VerticalDivider(
                          color: const Color.fromARGB(255, 59, 58, 58),
                          indent: 10,
                          endIndent: 10,
                          thickness: 0.1,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: SvgPicture.network('assets/icons/Filter.svg'),
                        ),
                      ],
                    ),
                  ),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
        ),

        // 👇 Fixed content below search bar
        // SizedBox(height: 150),
        // Container(
        //   height: 200,
        //   margin: EdgeInsets.symmetric(horizontal: 20),
        //   color: Colors.amber,
        //   child: Center(child: Text('Fixed Content Below')),
        // ),
      ],
    ),

    // 🧊 Floating suggestion box
    if (suggestions.isNotEmpty)
      Positioned(
        left: 20,
        right: 20,
        top: 100, // adjust if needed
        child: CompositedTransformFollower(
          link: _layerLink,
          showWhenUnlinked: false,
          offset: Offset(0, 60), // float it below TextField
          child: Material(
            elevation: 4,
            borderRadius: BorderRadius.circular(12),
            child: ListView.builder(
              padding: EdgeInsets.zero,
              shrinkWrap: true,
              itemCount: suggestions.length,
              itemBuilder: (context, index) {
                final person = suggestions[index];
                return ListTile(
                  title: Text(person.name),
                  subtitle: Text(person.job),
                  onTap: () {
                    _searchController.text = person.name;
                    setState(() {
                      suggestions.clear();
                    });
                  },
                );
              },
            ),
          ),
        ),
      ),
  ],
);

}
  Stack searchField() {
    return Stack(
      children: [
        Column(
          children : [
            CompositedTransformTarget(
              link: _layerLink,
              child : Container(
              margin : EdgeInsets.only(top : 40, left : 20, right : 20),
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: const Color.fromARGB(255, 183, 190, 194),
                    blurRadius: 40,
                    spreadRadius: 0.0,
                  )
                ],
              ),
              
              child: TextField(
                focusNode: _searchFocusNode,
                controller: _searchController,
                onChanged: _onSearchChanged,
                decoration: InputDecoration(
                  filled : true,
                  fillColor: Colors.white,
                  contentPadding: EdgeInsets.all(15),
                  hintText: 'Search',
                  hintStyle: TextStyle(
                    color : const Color.fromARGB(255, 81, 79, 79),
                    fontSize : 14,
                  ),
                  prefixIcon: Padding(
                    padding: const EdgeInsets.all(12),
                    child: SvgPicture.network('assets/icons/search.svg'),
                  ),
                  suffixIcon: Container(
                    width: 100,
                    child: IntrinsicHeight(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          VerticalDivider(
                            color : const Color.fromARGB(255, 59, 58, 58),
                            indent: 10,
                            endIndent: 10,
                            thickness: 0.1,
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: SvgPicture.network('assets/icons/Filter.svg'),
                          ),
                        ],
                      ),
                    ),
                  ),
                  border : OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide.none,
                  )
                ),
              ),
              )
          )
      ],
      
            // SizedBox(height: 10),
            //   Expanded(
            //     child: ListView.builder(
            //       itemCount: suggestions.length,
            //       itemBuilder: (context, index) {
            //         final person = suggestions[index];
            //         return ListTile(
            //           title: Text(person.name),
            //           subtitle: Text(person.job),
            //           onTap: () {
            //             // Set text to selected suggestion
            //             _searchController.text = person.name;
            //             setState(() {
            //               suggestions.clear(); // hide list
            //             });
            //           },
            //         );
            //       },
            //     ),
            //   )
      
      
      
      
      
      
      
          ),



if (suggestions.isNotEmpty)
      Positioned(
        width: MediaQuery.of(context).size.width - 40,
        left: 20,
        top: 100, // Adjust this based on TextField position
        child: CompositedTransformFollower(
          link: _layerLink,
          showWhenUnlinked: false,
          offset: Offset(0, 60), // Position below the TextField
          child: Material(
            elevation: 4,
            borderRadius: BorderRadius.circular(12),
            child: ListView.builder(
              padding: EdgeInsets.zero,
              shrinkWrap: true,
              itemCount: suggestions.length,
              itemBuilder: (context, index) {
                final person = suggestions[index];
                return ListTile(
                  title: Text(person.name),
                  subtitle: Text(person.job),
                  onTap: () {
                    _searchController.text = person.name;
                    setState(() {
                      suggestions.clear();
                    });
                  },
                );
              },
            ),
          ),
        ),
      ),






      ]
    );
  }

  AppBar appBar() {
    return AppBar(
      title : Text(
        'Smart-Shop',
        style : TextStyle(
          color : Colors.orange,
          fontSize: 24,
          fontWeight : FontWeight.bold
        )
      ),
      backgroundColor : const Color.fromARGB(255, 241, 224, 200),
      elevation : 0.0,
      // centerTitle: true,
      // leading : GestureDetector(
      //   onTap: () {
          
      //   },
      //   child: Container(
      //     margin : EdgeInsets.all(10),
      //     alignment: Alignment.center,
      //     decoration: BoxDecoration(
      //       color : const Color.fromARGB(255, 246, 240, 240),
      //       borderRadius: BorderRadius.circular(10)
      //     ),
      //     child : SvgPicture.network(
      //       'assets/icons/Arrow-Left2.svg',
      //       height : 20,
      //       width : 20
      //     ),
      //   ),
      // ),
      // actions : [
      //    GestureDetector(
      //     onTap: () {

      //     },
      //     child: Container(
      //       margin : EdgeInsets.all(10),
      //       alignment: Alignment.center,
      //       width : 37,
      //       decoration: BoxDecoration(
      //         color : const Color.fromARGB(255, 246, 240, 240),
      //         borderRadius: BorderRadius.circular(10)
      //       ),
      //       child : SvgPicture.network(
      //         'assets/icons/dots.svg',
      //         height : 5,
      //         width : 5, 
      //       ),
      //     ),
      //    ),
      // ]
    );
  }
}