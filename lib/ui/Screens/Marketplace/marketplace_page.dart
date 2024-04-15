import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:virtual_furnish_app/enums/item_category.dart';
class MarketplacePage extends StatefulWidget {
  const MarketplacePage({super.key});

  @override
  State<MarketplacePage> createState() => _MarketplacePageState();
}

class _MarketplacePageState extends State<MarketplacePage> {
  List<Image> advertisements = [
    Image.network(
        'https://mir-s3-cdn-cf.behance.net/project_modules/max_1200/08b6d354987911.5971a0fd31e99.jpg'),
    Image.network(
        'https://mir-s3-cdn-cf.behance.net/projects/404/e16bc9104726331.Y3JvcCwyNzI4LDIxMzMsMCw2.jpg')
  ];
  List categoryImages =[
    'assets/images/chair.png',
    'assets/images/table.png',
    'assets/images/cabinet.png',
    'assets/images/curtain.png',
    'assets/images/bed.png',
    'assets/images/drawer.png',
    'assets/images/baby_furniture.png',
    'assets/images/other.png',
  ];

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        //homeBloc.add(HomeDataFetched(title: title??""));
      },
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading:  false,
            title:SizedBox(
              height: 40,
              child: TextField(
              decoration: InputDecoration(
                hintText: 'Search ...',
                hintStyle: TextStyle(fontSize: 12, color: Colors.grey),
                //rectangular border
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10))
                ),
              ),
              autofocus: false, // Set to true if you want the text field to be focused initially
              onChanged: (value) {
                // You can perform search functionality here based on the input value
              },
                      ),
            ),
          actions: [
            IconButton(
              icon: Icon(Icons.search),
              onPressed: () {
                // You can perform search functionality here
                // For example, show a search overlay or navigate to a search screen
              },
            ),
          ],
        ),
        body: SingleChildScrollView(
          child:  Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Column(
                children: [
                  CarouselSlider(
                      items: advertisements,
                      options: CarouselOptions(
                        height: 130,
                        viewportFraction: 1.0,
                        initialPage: 0,
                        enableInfiniteScroll: true,
                        autoPlay: true,
                        autoPlayInterval: const Duration(seconds: 3),
                        autoPlayCurve: Curves.fastOutSlowIn,
                        scrollDirection: Axis.horizontal,
                      )),
                  SizedBox(
                    height: 10,
                  ),
                  //grid view of products category
                  GridView.builder(
                    shrinkWrap: true,
                    itemCount: 8,
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 4,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                    ),
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {
                          //navigate to category page
                          Navigator.pushNamed(context, '/item_list',
                              arguments: {'category': ItemCategoryExtension(ItemCategory.values[index]).name});
                        },
                        child: Column(
                          children: [
                            Container(
                              //add border
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              height: 50,
                              width: 54,
                              child:  Center(
                                child: SvgPicture.asset('assets/images/cat_chair.svg',
                                width: 50,
                                height: 50,
                                ),
                                // child: Image(image: AssetImage('assets/images/chair.png'),fit: BoxFit.cover,),
                              ),
                            ),
                            Flexible(
                              child: Text(
                                ItemCategoryExtension(ItemCategory.values[index]).name,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: 10, fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Divider(),
                  SizedBox(
                    height: 10,
                  ),
                  Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                    Text(
                      'Best Sellers',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    //link text
                    TextButton(
                        onPressed: () {}, child: Text('Top picks for you > '))
                  ]),
                  SizedBox(
                    height: 10,
                  ),
                  //list of best sellers
                  SizedBox(
                    height: 200,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      shrinkWrap: true,
                      itemCount: 10,
                      itemBuilder: (context, index) {
                        return Column(
                            children: [
                              Image.network(
                                  'https://mir-s3-cdn-cf.behance.net/project_modules/max_1200/08b6d354987911.5971a0fd31e99.jpg', height: 100,width: 100,),
                           
                                  Text(
                                    'Product Name',
                                    style: TextStyle(
                                        fontSize: 20, fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    'Price',
                                    style: TextStyle(
                                        fontSize: 15, fontWeight: FontWeight.bold),
                                  ),
                                
                              
                            ],
                          
                        );
                      },
                    ),
                  ),
                ],
              ),
          ),
          
        ),
      ),
    );
  }
}
