import 'package:flutter/material.dart';
import 'package:skeletons/skeletons.dart';

class Shimmer extends StatefulWidget {
  const Shimmer({super.key});

  @override
  State<Shimmer> createState() => _ShimmerState();
}

class _ShimmerState extends State<Shimmer> {
  @override
  Widget build(BuildContext context) {
    return SkeletonTheme(
      themeMode: ThemeMode.light,
      shimmerGradient: LinearGradient(
        colors: [
          Color(0xFFD8E3E7),
          Color(0xFFC8D5DA),
          Color(0xFFD8E3E7),
        ],
        stops: [
          0.1,
          0.5,
          0.9,
        ],
      ),
      darkShimmerGradient: LinearGradient(
        colors: [
          Color(0xFF222222),
          Color(0xFF242424),
          Color(0xFF2B2B2B),
          Color(0xFF242424),
          Color(0xFF222222),
        ],
        stops: [
          0.0,
          0.2,
          0.5,
          0.8,
          1,
        ],
        begin: Alignment(-2.4, -0.2),
        end: Alignment(2.4, 0.2),
        tileMode: TileMode.clamp,
      ),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          backgroundColor: Colors.white,
          body: Column(
            children: [
              const SizedBox(height: 40),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SkeletonLine(
                      style: SkeletonLineStyle(
                          height: 20,
                          width: 100,
                          borderRadius: BorderRadius.circular(8)),
                    ),
                    const SkeletonAvatar(
                      style: SkeletonAvatarStyle(
                          shape: BoxShape.circle, width: 40, height: 40),
                    ),
                  ],
                ),
              ),
              const Padding(
                padding: EdgeInsets.fromLTRB(12, 12, 0, 0),
                child: Row(
                  children: [
                    SkeletonAvatar(
                        style: SkeletonAvatarStyle(width: 70, height: 30)),
                    SizedBox(width: 10),
                    SkeletonAvatar(
                        style: SkeletonAvatarStyle(width: 70, height: 35)),
                    SizedBox(width: 10),
                    SkeletonAvatar(
                        style: SkeletonAvatarStyle(width: 70, height: 30)),
                    SizedBox(width: 10),
                    SkeletonAvatar(
                        style: SkeletonAvatarStyle(width: 70, height: 30)),
                    SizedBox(width: 10),
                    SkeletonAvatar(
                        style: SkeletonAvatarStyle(width: 70, height: 30)),
                  ],
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.76,
                child: ListView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: 5,
                  itemBuilder: (context, index) => Padding(
                    padding: const EdgeInsets.fromLTRB(8, 0, 8, 8.0),
                    child: Container(
                      padding: const EdgeInsets.fromLTRB(8, 0, 8, 8.0),
                      decoration: BoxDecoration(color: Colors.white),
                      child: SkeletonItem(
                          child: Column(
                        children: [
                          SkeletonAvatar(
                            style: SkeletonAvatarStyle(
                              width: double.infinity,
                              minHeight: MediaQuery.of(context).size.height / 4,
                              maxHeight: MediaQuery.of(context).size.height / 2,
                            ),
                          ),
                          const SizedBox(height: 8),
                          const Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              SkeletonAvatar(
                                style:
                                    SkeletonAvatarStyle(width: 40, height: 40),
                              ),
                              SizedBox(width: 15),
                              SkeletonAvatar(
                                style:
                                    SkeletonAvatarStyle(width: 40, height: 40),
                              ),
                              SizedBox(width: 30),
                              SkeletonAvatar(
                                style:
                                    SkeletonAvatarStyle(width: 40, height: 40),
                              ),
                              SizedBox(width: 15),
                              SkeletonAvatar(
                                style:
                                    SkeletonAvatarStyle(width: 40, height: 40),
                              ),
                            ],
                          ),
                        ],
                      )),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
