

import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:training_a/helper/decimal_rounder.dart';
import 'package:training_a/models/crypto_model/crypto_data.dart';
import 'package:training_a/providers/market_view_provider.dart';
import 'package:training_a/ui/ui_helper/shimmer_widget.dart';
import 'package:training_a/ui/ui_helper/theme_switcher.dart';

import '../network/response_model.dart';

class MarketViewPage extends StatefulWidget {
  const MarketViewPage({super.key});

  @override
  State<MarketViewPage> createState() => _MarketViewPageState();
}


class _MarketViewPageState extends State<MarketViewPage> {
  late Timer timer;
  @override
  void initState() {
    super.initState();
  final marketProvider = Provider.of<MarketViewProvider>(context,listen: false);
  marketProvider.getCryptoData();
  timer = Timer.periodic(Duration(seconds: 20), (timer ) => marketProvider.getCryptoData(),);
  }
  @override
  void dispose() {
   timer.cancel();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    var primaryColor = Theme.of(context).primaryColor;
    var borderColor = Theme.of(context).secondaryHeaderColor;
    var textTheme = Theme.of(context).textTheme;


    return SafeArea(child: Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        iconTheme: Theme.of(context).iconTheme,
        leading: IconButton(onPressed: (){}, icon: Icon(Icons.arrow_back)),
        actions: [
          ThemeSwitcher()
        ],
        centerTitle: true,
        title: Text("Market View"),
        titleTextStyle: textTheme.titleLarge,
      ),
      body: SizedBox(
        height: height,
        width: width,
        child: Column(

          children: [
            Expanded(
        child: Consumer<MarketViewProvider>(builder:
            (context, value, child) {
              switch(value.state.status){
                case Status.LOADING:
                  return ShimmerWidget();
                case Status.COMPLETE:
                 List<CryptoData>? model =value.dataFuture.data!.cryptoCurrencyList;
                 return Column(
                   children: [
                     Padding(
                       padding: const EdgeInsets.all(8.0),
                       child: TextField(

                         decoration: InputDecoration(
                           hintStyle: textTheme.bodySmall,
                           prefixIcon: Icon(Icons.search),
                           enabledBorder: OutlineInputBorder(
                             borderSide: BorderSide(color: borderColor),
                             borderRadius: BorderRadius.circular(15)
                           ),
                           border: OutlineInputBorder(
                             borderRadius: BorderRadius.circular(15),
                           )

                         ),
                       ),
                     ),
                     Expanded(child:
                      ListView.separated(
                          itemBuilder: (context, index) {
                            var number = index+1;
                            var tokenId = model[index].id;
                            var result = model[index].quotes![0];
                            MaterialColor filterColor = DecimalRounder.setColorFilter(result.percentChange24h);

                            var finalPrice = DecimalRounder.removePriceDecimal(result.price);

                            var percentChange = DecimalRounder.removePercentDecimal(result.percentChange24h);
                            Color percentColor = DecimalRounder.setPercentChangeColor(result.percentChange24h);
                            Icon percentIcon = DecimalRounder.setPercentChangeIcon(result.percentChange24h);
                            return Padding(
                              padding: const EdgeInsets.only(top: 8),
                              child: InkWell(
                                onTap: () {

                                },
                                child: SizedBox(
                                  height: height*0.075,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(left: 10),
                                        child: Text(number.toString(),style: textTheme.bodySmall,),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(left: 10,right: 15),
                                        child: CachedNetworkImage(
                                            fadeInDuration: Duration(milliseconds: 500),
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
                                            child: Text(model[index].name!,style: textTheme.bodySmall,),),
                                              Text(model[index].symbol!,style: textTheme.labelSmall,)
                                            ],
                                          )
                                      ),
                                      Flexible(
                                          fit: FlexFit.tight,
                                          child: ColorFiltered(colorFilter: ColorFilter.mode(filterColor, BlendMode.srcATop),
                                          child: SvgPicture.network("https://s3.coinmarketcap.com/generated/sparklines/web/1d/2781/$tokenId.svg",width: 100,),
                                          ),

                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(right: 10),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.end,
                                          mainAxisAlignment: MainAxisAlignment.center,
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
                                ),
                              ),
                            );
                          },
                          separatorBuilder: (context, index) => Divider(),
                          itemCount: model!.length)
              )


                   ],
                 );
                case Status.ERROR:
                  // TODO: Handle this case.
                  throw UnimplementedError();
                default:{
                  return Text("something wrong");
      }
              }
            },))
          ],
        ),
      )
    ));
  }
}
