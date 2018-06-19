import 'package:courses_in_english/controller/session.dart';
import 'package:courses_in_english/ics_creator.dart';
import 'package:courses_in_english/model/course/course.dart';
import 'package:courses_in_english/model/department/department.dart';
import 'package:courses_in_english/ui/screens/cie_screen.dart';
import 'package:courses_in_english/ui/screens/course_list_screen.dart';
import 'package:courses_in_english/ui/screens/favorites_screen.dart';
import 'package:courses_in_english/ui/screens/locations_screen.dart';
import 'package:courses_in_english/ui/screens/settings_screen.dart';
import 'package:courses_in_english/ui/screens/timetable_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_search_bar/flutter_search_bar.dart';

class HomeScaffold extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new _HomeScaffoldState();
}

class _HomeScaffoldState extends State<HomeScaffold> {
  static final int _initialIndex = 2;
  final PageController _controller =
      new PageController(initialPage: _initialIndex, keepPage: true);
  int _selectedIndex = _initialIndex;
  List<Course> displayedCourses = [];
  Session session = new Session();
  SearchBar searchBar;
  List<DropdownMenuItem<Department>> dropdownMenuItems = [];
  bool isFiltered = false;
  String _searchTerm;
  bool loading = true;

  // Builds the app bar depending on current screen
  // When on course_list screen, add search functionality
  AppBar buildAppBar(BuildContext context) {
    List<Widget> actions;
    if (_selectedIndex == 2) {
      actions = [
        new IconButton(
          icon: new Icon(Icons.calendar_today),
          onPressed: () {
            saveIcsFile(session.courses);
            AlertDialog dialog = new AlertDialog(
              content: new Text("Ics was saved to your Phones Storage"),
            );
            showDialog(
                context: context,
                builder: (context) {
                  return dialog;
                });
          },
        )
      ];
    } else if (_selectedIndex == 0) {
      actions = [
        searchBar.getSearchAction(context),
        new DropdownButton<Department>(
          items: dropdownMenuItems,
          onChanged: (Department dep) {
            _filterCoursesByDepartment(dep);
          },
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
          hint: Text("All Departments"),

        )
      ];
    }

    // If we are currently in filter mode, add clear button
    if (_selectedIndex == 0 && isFiltered) {
      actions.insert(
          0,
          IconButton(
              icon: Icon(Icons.clear),
              onPressed: () {
                setState(() {
                  this.displayedCourses = session.courses;
                  isFiltered = false;
                });
              }));
    }

    return new AppBar(
      title: isFiltered
          ? Text("search: \"" + _searchTerm + "\"")
          : Text('All Courses'),
      centerTitle: false,
      actions: actions,
      automaticallyImplyLeading: true,


    );
  }

  _searchCourses(String term) {
    List<Course> filteredCourses = new List<Course>();

    for (Course course in session.courses) {
      if ((course.name != null && course.name.contains(term)) ||
          course.description != null && course.description.contains(term)) {
        filteredCourses.add(course);
      }
    }

    setState(() {
      this.displayedCourses = filteredCourses;
      isFiltered = true;
      _searchTerm = term;
    });
  }

  _filterCoursesByDepartment(Department dep) {
    List<Course> filteredCourses = new List<Course>();

    if (dep.id == -1) {
      // If user selected "All departments", display all the courses
      filteredCourses = session.courses;
      isFiltered = false;
    } else {
      // Else filter out only those that correspond to the selected department
      _searchTerm = "FK " + dep.number.toString();
      for (Course course in session.courses) {
        if ((course.department.id == dep.id)) {
          filteredCourses.add(course);
        }
      }
    }

    setState(() {
      this.displayedCourses = filteredCourses;
      isFiltered = true;
    });
  }

  _HomeScaffoldState() {
    session.callbacks.add((session) {
      if (mounted) {
        setState(() {
          displayedCourses = session.courses;
          dropdownMenuItems.add(DropdownMenuItem(
              value: Department(-1, -1, "ALL", 0),
              child: Text("All departments")));
          for (Department dep in session.departments) {
            dropdownMenuItems.add(DropdownMenuItem(
                value: dep, child: Text("FK" + dep.number.toString())));
          }
          loading = false;
        });
      }
    });
    // TODO error handling for download
    session.download();
    // Initialize searchBar
    searchBar = new SearchBar(
        inBar: true,
        setState: setState,
        onSubmitted: _searchCourses,
        buildDefaultAppBar: buildAppBar);
  }

  @override
  Widget build(BuildContext context) {
    Widget scaffold;
    if (!loading) {
      List<Widget> screens = [
        new CourseListScreen(displayedCourses, session.favorites),
        new LocationScreen(session.campuses),
        new TimetableScreen(session.courses),
        new FavoriteListScreen(session.favorites),
        new CieScreen(),
        new SettingsScreen()
      ];
      scaffold = new Scaffold(
        bottomNavigationBar: new BottomNavigationBar(
          items: [
            new BottomNavigationBarItem(
              icon: new Icon(Icons.import_contacts),
              title: new Text('Courses'),
            ),
            new BottomNavigationBarItem(
              icon: new Icon(Icons.map),
              title: new Text('Maps'),
            ),
            new BottomNavigationBarItem(
              icon: new Icon(Icons.calendar_today),
              title: new Text('Timetable'),
            ),
            new BottomNavigationBarItem(
              icon: new Icon(Icons.favorite_border),
              title: new Text('Favorites'),
            ),
            new BottomNavigationBarItem(
              icon: new Icon(Icons.account_circle),
              title: new Text('Profile'),
            ),
            new BottomNavigationBarItem(
              icon: new Icon(Icons.settings),
              title: new Text('Settings'),
            ),
          ],
          type: BottomNavigationBarType.fixed,
          currentIndex: _selectedIndex,
          onTap: (newIndex) {
            setState(() {
              _selectedIndex = newIndex;
              _controller.jumpToPage(newIndex);
            });
          },
        ),
        appBar: searchBar.build(context),
        body: new PageView(
          controller: _controller,
          children: screens,
          onPageChanged: (newIndex) {
            setState(() {
              _selectedIndex = newIndex;
            });
          },
        ),
      );
    } else {
      scaffold = new Scaffold(
        body: new Center(
          child: new Image(image: new AssetImage("res/anim_cow.gif")),
        ),
      );
    }
    return scaffold;
  }
}
