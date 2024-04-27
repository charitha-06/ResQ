


import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:res_q/Utils/quote.dart';
import 'package:url_launcher/url_launcher.dart';

class slider extends StatelessWidget {
  const slider ({Key ? key}) : super(key: key);



  @override
  Widget build( BuildContext){
    return Container(

      child : Padding(
        padding: const EdgeInsets.only(top: 25.0),

      child: CarouselSlider(
        options: CarouselOptions(
          aspectRatio: 0.9,
          autoPlay: true,
          enlargeCenterPage: true,
        ),
        items: List.generate(imageForSLiders.length, (index) => Card(
          elevation: 5.0,
          shape: RoundedRectangleBorder(
            borderRadius:BorderRadius.circular(20),
          ),
          child : InkWell(
            onTap: () async{
                  if(index == 0){
                    final url =  Uri.parse( 'https://medium.com/@karen_flintoclass/28-important-basic-safety-rules-for-kids-you-shouldnt-miss-84426b9ebbed' );
                    if(await canLaunchUrl(url)){
                      await launchUrl(url);
                      print("clicked");
                    }
                  }

                  else if(index == 1){
                      final url =  Uri.parse( 'https://www.nationwide.com/lc/resources/home/articles/senior-citizen-safety' );
                        if(await canLaunchUrl(url)){
                          await launchUrl(url);
                          print("clicked");
                  }

                  }
                  else if(index == 2){
                    final url =  Uri.parse( 'https://www.slma.cc/sexual-assault-awareness-prevention/' );
                    if(await canLaunchUrl(url)){
                      await launchUrl(url);
                      print("clicked");
                    }

                  }

                  else if(index == 3){
                    final url =  Uri.parse( 'https://www.myflowertree.com/blog/why-self-defence-is-so-important-for-women' );
                    if(await canLaunchUrl(url)){
                      await launchUrl(url);
                      print("clicked");
                    }

                  }
                  else if(index == 4){
                    final url =  Uri.parse( 'https://www.childrenssafetynetwork.org/child-safety-topics/bullying-prevention' );
                    if(await canLaunchUrl(url)){
                      await launchUrl(url);
                      print("clicked");
                    }

                  }
                  else if(index == 5){
                    final url =  Uri.parse( 'https://360info.org/how-empowering-kids-can-help-protect-them-from-abuse/' );
                    if(await canLaunchUrl(url)){
                      await launchUrl(url);
                      print("clicked");
                    }

                  }


            },
            child: Container(
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Colors.blue.withOpacity(0.4), // Shadow color
                    spreadRadius: 3, // Spread radius
                    blurRadius: 7, // Blur radius
                    offset: Offset(1, 3), // Shadow position, positive values move the shadow to the right and down
                  ),
                ],
                borderRadius: BorderRadius.circular(10),
                image : DecorationImage(
                  fit: BoxFit.cover,
                    image:NetworkImage(
                        imageForSLiders[index]),
                ),
              ),

              child: Align(
                alignment: Alignment.bottomLeft,
              child :Padding(
                  padding: const EdgeInsets.only(left: 25.0 , bottom: 25.0),

                  child: Text(articleTitle[index],
              style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.white,
              fontSize: MediaQuery.of(BuildContext).size.width * 0.05,
              ),
              )
              )
          )
          ),
        )
        ),
      )
      )
      )
    ) ;
  }
}