import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:marquee/marquee.dart';
import 'package:provider/provider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:training_a/helper/decimal_rounder.dart';
import 'package:training_a/models/crypto_model/crypto_data.dart';
import 'package:training_a/network/response_model.dart';
import 'package:training_a/providers/crypto_data_provider.dart';
import 'package:training_a/ui/ui_helper/home_page_view.dart';
import 'package:training_a/ui/ui_helper/shimmer_widget.dart';
import 'package:training_a/ui/ui_helper/theme_switcher.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_svg/flutter_svg.dart';

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
    final cryptoProvider = Provider.of<CryptoDataProvider>(context);
    var height = MediaQuery.of(context).size.height;

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
                                switch(index){
                                  case 0:
                                    cryptoProvider.getTopMarketCapData();
                                    break;
                                    case 1:
                                    cryptoProvider.getTopGainersData();
                                    break;
                                    case 2:
                                    cryptoProvider.getTopLooserData();
                                    break;
                                    default:
                                    cryptoProvider.getTopMarketCapData();
                                    break;

                                }

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
                  height: height/2.5,
                  width: double.infinity,
                  child: Consumer<CryptoDataProvider>(
                    builder: (context, cryptoDataProvider, child) {
                      if (cryptoDataProvider.state.status case Status.LOADING) {
                        return ShimmerWidget();
                      } else if (cryptoDataProvider.state.status case Status.COMPLETE) {
                        List<CryptoData>? model = cryptoDataProvider.dataFuture.data!.cryptoCurrencyList;


                        return ListView.separated(

                          physics: BouncingScrollPhysics(),
                            itemBuilder: (context, index) {
                              var number = index +1;
                              var tokenId = model[index].id;
                              MaterialColor filterColor = DecimalRounder.setColorFilter(model[index].quotes![0].percentChange24h);
                              var finalPrice = DecimalRounder.removePriceDecimal(model[index].quotes![0].price);

                              var percentChange = DecimalRounder.removePercentDecimal(model[index].quotes![0].percentChange24h);
                              Color percentColor = DecimalRounder.setPercentChangeColor(model[index].quotes![0].percentChange24h);
                              Icon percentIcon = DecimalRounder.setPercentChangeIcon(model[index].quotes![0].percentChange24h);

                              return SizedBox(
                                height: height*0.075,
                                child: Row(

                                  children: [
                                      Padding(
                                        padding: const EdgeInsets.only(left: 10),
                                        child: Text(number.toString(),style: textTheme.bodySmall,),
                                      ),
                                     Padding(
                                       padding: const EdgeInsets.only(left: 10,right: 15),
                                       child: CachedNetworkImage(
                                         fadeInDuration: Duration(milliseconds: 500) ,
                                         height: 32,
                                         width: 32,
                                         imageUrl: 'https://s2.coinmarketcap.com/static/img/coins/32x32/$tokenId.png',
                                         placeholder: (context, url) => CircularProgressIndicator(),
                                         errorWidget: (context, url, error) => Icon(Icons.error),

                                       ),

                                     ),
                                    Flexible(
                                        fit: FlexFit.tight,
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            SizedBox(
                                              width: 100,
                                                child: Text(model[index].name!,style: textTheme.bodySmall,)),
                                            Text(model[index].symbol!,style: textTheme.labelSmall,)
                                          ],
                                        ))
                                    ,
                                    Flexible(
                                      fit: FlexFit.tight,
                                        child: ColorFiltered(
                                          colorFilter: ColorFilter.mode(filterColor, BlendMode.srcATop),
                                            child: SvgPicture.network("https://s3.coinmarketcap.com/generated/sparklines/web/1d/2781/$tokenId.svg",width: 100,)
                                        )
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(right: 10),
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        crossAxisAlignment: CrossAxisAlignment.end,
                                        children: [
                                          Text("\$$finalPrice",style: textTheme.bodySmall,),
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.end,
                                            children: [
                                              percentIcon,
                                              Text("$percentChange%",style: GoogleFonts.ubuntu(color: percentColor,fontSize: 13),)
                                            ],
                                          )
                                        ],
                                      ),
                                    )

                                  ],
                                ),
                              );
                            },
                            separatorBuilder: (context, index) {
                              return Divider();
                            },
                            itemCount: model!.length);
                      } else  {
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
