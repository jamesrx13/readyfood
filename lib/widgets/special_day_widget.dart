import 'package:animate_do/animate_do.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:ready_food/models/plate_model.dart';
import 'package:ready_food/pages/plate_info_page.dart';

class SpecialDayWidget extends StatefulWidget {
  final String restaurantId;
  const SpecialDayWidget({Key? key, required this.restaurantId})
      : super(key: key);

  @override
  State<SpecialDayWidget> createState() => _SpecialDayWidgetState();
}

class _SpecialDayWidgetState extends State<SpecialDayWidget> {
  List<PlateModel> specialPlates = [];

  @override
  void initState() {
    FirebaseDatabase.instance
        .ref('restaurants/${widget.restaurantId}/plates/')
        .orderByChild('isSpecial')
        .equalTo(true)
        .onValue
        .listen(
      (event) {
        specialPlates.clear();
        for (var element in event.snapshot.children) {
          PlateModel specialPlateTemp = PlateModel(
              id: element.key.toString(),
              countSold: element.child('countSold').exists
                  ? int.parse(element.child('countSold').value.toString())
                  : 0,
              description: element.child('plateDescription').value.toString(),
              hasStock: element.child('hasStock').value as bool,
              imageUrl: element.child('plateImageUrl').value.toString(),
              isSpecial: element.child('isSpecial').value as bool,
              name: element.child('plateName').value.toString(),
              price: int.parse(element.child('platePrice').value.toString()));
          specialPlates.add(specialPlateTemp);
        }
        setState(() {});
      },
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;

    PageController controller = PageController(
      initialPage: 1,
      viewportFraction: 0.9,
    );
    List<Widget> banners = [];
    const customStyle = TextStyle(
      fontSize: 18.0,
      fontStyle: FontStyle.italic,
    );
    for (var i = 0; i < specialPlates.length; i++) {
      var itemView = Padding(
        padding: const EdgeInsets.all(10.0),
        child: GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => PlateInfoPage(
                  palto: specialPlates[i],
                  isRestaurant: false,
                  restaurantAssocId: widget.restaurantId,
                ),
              ),
            );
          },
          child: Stack(
            fit: StackFit.expand,
            children: [
              Container(
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(25)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black38,
                      offset: Offset(
                        2.0,
                        2.0,
                      ),
                      blurRadius: 5.0,
                      spreadRadius: 1.0,
                    ),
                  ],
                ),
              ),
              ClipRRect(
                borderRadius: const BorderRadius.all(Radius.circular(25)),
                child: Hero(
                  tag: specialPlates[i].id,
                  child: FadeInImage.assetNetwork(
                    image: specialPlates[i].imageUrl,
                    placeholder: 'lib/img/loading.gif',
                    width: 110.0,
                    height: 80.0,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Container(
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(25)),
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Colors.black38,
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      specialPlates[i].name,
                      style: const TextStyle(
                        fontSize: 25.0,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      specialPlates[i].description,
                      style: const TextStyle(
                        fontSize: 12.0,
                        color: Colors.white,
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      );
      banners.add(itemView);
    }

    return (specialPlates.isNotEmpty)
        ? SizedBox(
            width: screenWidth,
            height: screenWidth * 9 / 12,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                    bottom: 8.0,
                    left: 20.0,
                    top: 20.0,
                  ),
                  child: SizedBox(
                    height: 20.0,
                    child: Flash(
                      duration: const Duration(seconds: 3),
                      child: const Text(
                        'ESPECIALES',
                        style: customStyle,
                      ),
                      animate: true,
                      infinite: true,
                    ),
                  ),
                ),
                Expanded(
                  child: PageView(
                    physics: const BouncingScrollPhysics(),
                    controller: controller,
                    scrollDirection: Axis.horizontal,
                    children: banners,
                  ),
                ),
              ],
            ),
          )
        : Padding(
            padding: const EdgeInsets.all(10.0),
            child: Row(
              children: const [
                Text(
                  'Sin especiales',
                  style: TextStyle(
                    fontSize: 15.0,
                  ),
                ),
              ],
            ),
          );
  }
}
