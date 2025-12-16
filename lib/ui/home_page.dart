import 'package:flutter/material.dart';
import 'package:marquee/marquee.dart';
import 'package:provider/provider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:training_a/network/response_model.dart';
import 'package:training_a/providers/crypto_data_provider.dart';
import 'package:training_a/ui/ui_helper/home_page_view.dart';
import 'package:training_a/ui/ui_helper/theme_switcher.dart';
import 'package:shimmer/shimmer.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final PageController _pageViewController = PageController(initialPage: 0);

  var defaultPageIndex = 0;

  final List<String> _choicesList = [
    'Top MarketCaps',
    'Top Gainers',
    'Top Losers',
  ];

  @override
  void initState() {
    super.initState();
    final cryptoProvider = Provider.of<CryptoDataProvider>(
      context,
      listen: false,
    );
    cryptoProvider.getTopMarketCapData();
  }

  @override
  Widget build(BuildContext context) {
    var primaryColor = Theme.of(context).primaryColor;
    TextTheme textTheme = Theme.of(context).textTheme;
    return SafeArea(
      child: Scaffold(
        drawer: Drawer(),
        appBar: AppBar(
          backgroundColor: primaryColor,
          actions: [ThemeSwitcher()],
          centerTitle: true,
          titleTextStyle: textTheme.titleLarge,
          title: Text("Digital Currency"),
        ),
        body: SizedBox(
          height: double.infinity,
          width: double.infinity,
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            physics: BouncingScrollPhysics(),
            child: Column(
              children: [
                //banner page view
                Padding(
                  padding: EdgeInsets.only(top: 10, left: 5, right: 5),
                  child: SizedBox(
                    height: MediaQuery.of(context).size.height / 5,
                    width: double.infinity,
                    child: Stack(
                      children: [
                        HomePageView(controller: _pageViewController),
                        Align(
                          alignment: Alignment.bottomCenter,
                          child: Padding(
                            padding: EdgeInsets.only(bottom: 10),
                            child: SmoothPageIndicator(
                              controller: _pageViewController,
                              count: 4,
                              effect: ExpandingDotsEffect(
                                dotColor: Colors.white,
                                dotWidth: 10,
                                dotHeight: 10,
                              ),
                              onDotClicked: (index) =>
                                  _pageViewController.animateToPage(
                                    index,
                                    duration: Duration(milliseconds: 300),
                                    curve: Curves.easeInOut,
                                  ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                SizedBox(
                  height: 30,
                  width: double.infinity,
                  child: Marquee(
                    style: textTheme.bodySmall,
                    text: "🔊 This is a Place for News in Application",
                  ),
                ),
                SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.only(left: 5, right: 5),
                  child: Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green[700],
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            padding: EdgeInsets.all(20),
                          ),
                          child: Text("buy"),
                        ),
                      ),
                      SizedBox(width: 10),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red[700],
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            padding: EdgeInsets.all(20),
                          ),
                          child: Text("sell"),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.only(left: 5, right: 5),
                  child: Row(
                    children: [
                      Wrap(
                        spacing: 8,
                        children: List.generate(_choicesList.length, (index) {
                          return ChoiceChip(
                            label: Text(
                              _choicesList[index],
                              style: textTheme.titleSmall,
                            ),
                            selected: defaultPageIndex == index,
                            selectedColor: Colors.blue,
                            onSelected: (value) => {
                              setState(() {
                                defaultPageIndex = value
                                    ? index
                                    : defaultPageIndex;
                              }),
                            },

                            backgroundColor: Colors.grey[700],
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          );
                        }),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 10),
                SizedBox(
                  height: 500,
                  child: Consumer<CryptoDataProvider>(
                    builder: (context, cryptoDataProvider, child) {
                      switch (context.watch<CryptoDataProvider>().state.status) {
                        case Status.LOADING:
                          return SizedBox(
                            height: 80,
                            child: Shimmer.fromColors(
                                baseColor: Colors.grey.shade400,
                                highlightColor: Colors.white,
                                 child: ListView.builder(
                                     itemCount: 10,
                                     itemBuilder: (context, index) {
                                       return Row(

                                         children: [
                                           Padding(
                                             padding: const EdgeInsets.only(top: 8,bottom: 8,left: 8),
                                             child: CircleAvatar(
                                               backgroundColor: Colors.white,
                                               radius: 30,
                                               child: Icon(Icons.add),
                                             ),
                                           ),
                                           Flexible(
                                               fit: FlexFit.tight,
                                               child: Padding(
                                                 padding: const EdgeInsets.only(right: 8,left: 8),
                                                 child: Column(
                                                   crossAxisAlignment: CrossAxisAlignment.start,
                                                   children: [
                                                     SizedBox(
                                                       width: 50,
                                                       height: 15,
                                                       child: Container(
                                                         decoration: BoxDecoration(
                                                           borderRadius: BorderRadius.circular(10),
                                                           color: Colors.white
                                                         ),
                                                       ),
                                                     ),
                                                     Padding(
                                                       padding: const EdgeInsets.only(top: 8),
                                                       child: SizedBox(
                                                         width: 25,
                                                         height: 15,
                                                         child: Container(
                                                           decoration: BoxDecoration(
                                                             borderRadius: BorderRadius.circular(10),
                                                             color: Colors.white
                                                           ),
                                                         ),
                                                       ),
                                                     ),
                                                   ],
                                                 ),
                                               )),
                                           Flexible(
                                               fit: FlexFit.tight,
                                               child: SizedBox(
                                                 width: 70,
                                                 height: 40,
                                                 child: Container(
                                                   decoration: BoxDecoration(
                                                     borderRadius: BorderRadius.circular(10),
                                                     color: Colors.white
                                                   ),
                                                 ),
                                               )),
                                           Flexible(
                                             fit: FlexFit.tight,
                                               child: Padding(
                                                 padding: const EdgeInsets.only(right: 8,),
                                                 child: Column(
                                                   crossAxisAlignment: CrossAxisAlignment.end,
                                                   children: [
                                                     SizedBox(
                                                       width: 50,
                                                       height: 15,
                                                       child: Container(
                                                         decoration: BoxDecoration(
                                                           borderRadius: BorderRadius.circular(10),
                                                           color: Colors.white
                                                         ),
                                                       ),
                                                     ),
                                                     Padding(
                                                       padding: const EdgeInsets.only(top: 8),
                                                       child: SizedBox(
                                                         width: 25,
                                                         height: 15,
                                                         child: Container(
                                                           decoration: BoxDecoration(
                                                             borderRadius: BorderRadius.circular(10),
                                                             color: Colors.white
                                                           ),
                                                         ),
                                                       ),
                                                     ),
                                                   ],
                                                 ),
                                               ))
                                         ],
                                       );
                                     },),
                            ),
                          );
                        case Status.COMPLETE:
                          return Text("done");
                        case Status.ERROR:
                          return Text(cryptoDataProvider.state.message);

                      }
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
