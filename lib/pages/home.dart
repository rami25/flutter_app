import 'package:flutter/material.dart';
import 'package:flutter_application_1/models/category_model.dart';
import 'package:flutter_application_1/pages/profile.dart';
import 'package:flutter_application_1/pages/receipts.dart';
import 'package:flutter_application_1/pages/signInOrUp.dart';
import 'package:flutter_application_1/pages/signInPage.dart';
import 'package:flutter_application_1/pages/signUpPage.dart';
import 'package:flutter_application_1/services/api.dart';
import 'package:flutter_svg/flutter_svg.dart';

class HomePage extends StatefulWidget {
  HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<CategoryModel> categories1 = [];
  List<CategoryModel> categories2 = [];

  final api = Api();
  bool _isLoggedIn = false;

  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }
  // Function to check if the user is logged in
  Future<void> _checkLoginStatus() async {
    bool isLoggedIn = await api.isLoggedIn();
    setState(() {
      _isLoggedIn = isLoggedIn;
    });
  }

  int _currentIndex = 0;
  final FocusNode _searchFocusNode = FocusNode();
  final TextEditingController _searchController = TextEditingController();

  void getAll() {
    categories1 = CategoryModel.getCategories1();
    categories2 = CategoryModel.getCategories2();
  }

  @override
  Widget build(BuildContext context) {
    getAll();
    return Scaffold(
      appBar: appBar(),
      endDrawer: drawer(context),
      backgroundColor: Colors.indigo[50],
      body : Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          searchField(),
          SizedBox(height : 40,),
          // Title
          Padding(
            padding: const EdgeInsets.only(left: 20),
            child: Text(
              'Category',
              style: TextStyle(
                color: Colors.blueGrey[800],
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Expanded( 
            child : categoriesSection(),
          )
        ],
      ),
      bottomNavigationBar: bottomNavBar(),
    );
  }

  BottomNavigationBar bottomNavBar() {
    return BottomNavigationBar(
      currentIndex: _currentIndex,
      onTap: _onTabTapped,
      selectedItemColor: Colors.blueGrey[800],
      backgroundColor : Colors.indigo[50],
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

    if (index == 2) {
      if (!_isLoggedIn) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const SignInOrUp()),
        );
      } else {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ProfilePage()),
        );
      }
    }
  }

  @override
  void dispose() {
    _searchFocusNode.dispose();
    _searchController.dispose();
    super.dispose();
  }
  ///

  Drawer drawer(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          Container(
            height: 65,
            child: DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blueGrey[800],
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
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => HomePage()),
              );
              //Navigator.pop(context); // Close drawer
              // Add your navigation logic here
            },
          ),
          if (_isLoggedIn)
            ListTile(
              leading: const Icon(Icons.person),
              title: const Text('Profile'),
              onTap: () {
                if (!_isLoggedIn) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SignInOrUp()),
                  );
                } else {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ProfilePage()),
                  );
                }
              },
            ),
          if (_isLoggedIn)
            ListTile(
              leading: const Icon(Icons.note),
              title: const Text('Receipts'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ReceiptsPage()),
                );
              },
            ),
          if (_isLoggedIn)
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('Settings'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => HomePage()),
                );
              },
            ),
          if (_isLoggedIn) 
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Logout'),
              onTap: () async {
                await api.logout();
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => HomePage()),
                );
              },
            ),
          if (!_isLoggedIn) 
            ListTile(
              leading: const Icon(Icons.login),
              title: const Text('Sign In'),
              onTap: () async {
                await api.logout();
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SignInPage()),
                );
              },
            ),
          if (!_isLoggedIn) 
            ListTile(
              leading: const Icon(Icons.create),
              title: const Text('Sign Up'),
              onTap: () async {
                await api.logout();
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SignUpPage()),
                );
              },
            ),
        ],
      ),
    );
  }

  ListView categoriesSection() {
    return ListView(
      padding: const EdgeInsets.symmetric(vertical: 20),
      children: [
        const SizedBox(height: 15),
        _buildHorizontalList1(),
        const SizedBox(height: 20),
        _buildHorizontalList2(),
      ],
    );
  }

 
  Widget _buildHorizontalList1() {
    return SizedBox(
      height: 150, // Ensure enough height for the horizontal list
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        itemCount: categories1.length,
        separatorBuilder: (context, index) => const SizedBox(width: 25),
        itemBuilder: (context, index) {
          return Container(
            width: 135,
            decoration: BoxDecoration(
              color: categories1[index].boxColor.withOpacity(0.3),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(
                  width: 110,
                  height: 110,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Image.network(categories1[index].iconPath),
                  ),
                ),
                Text(
                  categories1[index].name,
                  style: const TextStyle(
                    fontWeight: FontWeight.w400,
                    color: Colors.black,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

 Widget _buildHorizontalList2() {
    return SizedBox(
      height: 150, // Ensure enough height for the horizontal list
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        itemCount: categories2.length,
        separatorBuilder: (context, index) => const SizedBox(width: 25),
        itemBuilder: (context, index) {
          return Container(
            width: 135,
            decoration: BoxDecoration(
              color: categories2[index].boxColor.withOpacity(0.3),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(
                  width: 110,
                  height: 110,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Image.network(categories2[index].iconPath),
                  ),
                ),
                Text(
                  categories2[index].name,
                  style: const TextStyle(
                    fontWeight: FontWeight.w400,
                    color: Colors.black,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

   Container searchField() {
     return Container(
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
         );
   }
 

  AppBar appBar() {
    return AppBar(
      title : Text(
        'Smart-Shop',
        style : TextStyle(
          color : Colors.white,
          fontSize: 24,
          fontWeight : FontWeight.bold
        )
      ),
      backgroundColor: Colors.blueGrey[800],
      elevation : 0.0,
    );
  }
}