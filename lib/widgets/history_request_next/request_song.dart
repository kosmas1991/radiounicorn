import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:radiounicorn/cubits/filteredlist/filteredlist_cubit.dart';
import 'package:radiounicorn/cubits/searchstring/searchstring_cubit.dart';
import 'package:radiounicorn/logic/functions.dart';
import 'package:transparent_image/transparent_image.dart';

class RequestSong extends StatelessWidget {
  const RequestSong({
    super.key,
    required this.textEditingController,
    required this.screenWidth,
    required this.screenHeight,
  });

  final TextEditingController textEditingController;
  final double screenWidth;
  final double screenHeight;

  @override
  Widget build(BuildContext context) {
    return TextButton.icon(
      onPressed: () {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
              backgroundColor: Color.fromARGB(255, 42, 42, 42),
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Request Song',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.close,
                      color: Colors.grey,
                      size: 20,
                    ),
                    onPressed: () {
                      textEditingController.text = '';
                      context.read<SearchstringCubit>().emitNewSearch('');
                      Navigator.pop(context);
                    },
                  )
                ],
              ),
              content: Column(
                children: [
                  Flexible(
                    flex: 1,
                    child: TextField(
                      controller: textEditingController,
                      onChanged: (value) {
                        textEditingController.text = value;
                        context.read<SearchstringCubit>().emitNewSearch(value);
                      },
                      style: TextStyle(color: Colors.white, fontSize: 20),
                      maxLines: 1,
                      cursorColor: Colors.blue,
                      decoration: InputDecoration(
                          hintText: 'Search a song or artist ...',
                          hintStyle: TextStyle(
                              color: Colors.grey,
                              fontSize: 15,
                              fontStyle: FontStyle.italic),
                          enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.white)),
                          focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.white)),
                          suffixIcon: Icon(
                            Icons.search,
                            color: Colors.white,
                          )),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Flexible(
                      flex: 9,
                      child: BlocBuilder<FilteredlistCubit, FilteredlistState>(
                        builder: (context1, state) {
                          return Container(
                            width: screenWidth * 8 / 9,
                            height: screenHeight * 8 / 9,
                            child: ListView.builder(
                              itemCount: state.filteredList.length,
                              itemBuilder: (context2, index) => Column(
                                children: [
                                  InkWell(
                                    onTap: () {
                                      requestNewSong(state
                                          .filteredList[index].requestUrl!);
                                      Navigator.pop(context);
                                    },
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Container(
                                          width: 25,
                                          child: Text(
                                            textAlign: TextAlign.center,
                                            (index + 1).toString(),
                                            style: TextStyle(
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          width: 5,
                                        ),
                                        Container(
                                          height: 50,
                                          width: 50,
                                          child: FadeInImage.memoryNetwork(
                                            placeholder: kTransparentImage,
                                            image:
                                                '${state.filteredList[index].song!.art}',
                                          ),
                                        ),
                                        SizedBox(
                                          width: 5,
                                        ),
                                        Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Container(
                                              width: screenWidth * 1 / 2.5,
                                              child: Text(
                                                '${state.filteredList[index].song!.title}',
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 12,
                                                    fontWeight:
                                                        FontWeight.bold),
                                                overflow: TextOverflow.clip,
                                                maxLines: 2,
                                              ),
                                            ),
                                            Container(
                                              width: screenWidth * 1 / 2.5,
                                              child: Text(
                                                '${state.filteredList[index].song!.artist}',
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 10),
                                                overflow: TextOverflow.clip,
                                                maxLines: 2,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    height: 15,
                                  )
                                ],
                              ),
                            ),
                          );
                        },
                      )),
                ],
              )),
        );
      },
      icon: Icon(
        Icons.audiotrack_sharp,
        color: Colors.white,
      ),
      label: Text(
        'Request Song',
        style: TextStyle(color: Colors.white),
      ),
    );
  }
}
