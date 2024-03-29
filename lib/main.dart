
import 'package:flutter/material.dart'; 
import 'package:sendbird_chat_sdk/sendbird_chat_sdk.dart';

 
void main()async { 
  WidgetsFlutterBinding.ensureInitialized();
  await SendbirdChat.init(appId:"BC823AD1-FBEA-4F08-8F41-CF0D9D280FBF");
  runApp(const ChatWidget()); 
} 
 
class ChatWidget extends StatelessWidget { 

  const ChatWidget({Key?key}):super(key: key);

  @override 
  Widget build(BuildContext context) { 
    return MaterialApp( 
      title: 'Test APp', 
      debugShowCheckedModeBanner: false,
      theme: ThemeData( 
        primarySwatch: Colors.blue, 
      ), 
      home: const ChatScreenWidget(), 
    ); 
  } 
} 
  
class ChatScreenWidget extends StatefulWidget { 

  const ChatScreenWidget({Key?key}):super(key:key);

  @override
  State<ChatScreenWidget> createState()=>_ChatWidgetState();

} 
 
class _ChatWidgetState extends State<ChatScreenWidget> { 

  List<BaseMessage> messages = [];
  bool startTyping = false;

  @override void initState() {
    super.initState();
    getMessages();
  }

  void getMessages() async{
    final params = MessageListParams()
    ..inclusive = true
    ..previousResultSize = 10
    ..nextResultSize = 0;
    const url = "https://api-BC823AD1-FBEA-4F08-8F41-CF0D9D280FBF.sendbird.com/v3/open_channels/sendbird_open_channel_14092_bf4075fbb8f12dc0df3ccc5c653f027186ac9211";
    final channel = await OpenChannel.getChannel("sendbird_open_channel_14092_bf4075fbb8f12dc0df3ccc5c653f027186ac9211");
    await channel.enter();
    try{
       final result = await channel.getMessagesByTimestamp(double.maxFinite.toInt(),params);
       print(result);
    }catch(e){
      print('the error is $e');
    }
  }

  final List<String> _messages = [ 
    "Hello!", 
    "Hi there!", 
    "How are you?", 
    "I'm doing well, thank you!", 
    "That's good to hear!", 
  ]; 

  List<Widget> getChatInput(){
    List<Widget> defaultWidget = [];
    defaultWidget.add(  IconButton(icon:const Icon(Icons.add),onPressed:()=>{},color:Colors.white,));
    Widget textField = SizedBox(
        width:MediaQuery.of(context).size.width*0.8,
        height:50,
        child:TextField(
          onTap: ()=>setState(() {
            startTyping = true;
          }),
          decoration:InputDecoration(
            filled: true,
            fillColor:Colors.transparent,
            contentPadding:const EdgeInsets.symmetric(horizontal:10,vertical:10),
            enabledBorder:OutlineInputBorder(
              borderRadius:BorderRadius.circular(30),
              borderSide:const BorderSide(color:Color.fromARGB(96, 182, 181, 181),width:1)
            ),
            focusedBorder:OutlineInputBorder(
              borderRadius:BorderRadius.circular(30),
              borderSide:const BorderSide(color:Color.fromARGB(96, 182, 181, 181),width:1)
            ),
            suffixIcon:Container(
              margin:const EdgeInsets.symmetric(vertical:8,horizontal:8),
              width:20,
              height:20,
              decoration:BoxDecoration(color:startTyping ? const Color.fromARGB(255, 235, 69, 124):const Color.fromARGB(166, 158, 158, 158),borderRadius:BorderRadius.circular(40)),
              child:GestureDetector(
                child:const Icon(Icons.arrow_upward,color:Colors.black,size: 18),
              )
            ),
            hintText: "聊天聊天"
          ),
      ) ,);
    defaultWidget.add(textField);
    return defaultWidget;
  }
 
  @override 
  Widget build(BuildContext context) { 
    return Scaffold(
      backgroundColor:Colors.black,
      appBar:AppBar(
        centerTitle:true,
        backgroundColor:Colors.transparent,
        title:const Text('聊天聊天'),
        leading:IconButton(onPressed:()=>Navigator.pop(context), icon:const Icon(Icons.arrow_back)),
        actions: [
          IconButton(onPressed:()=>{}, icon:const Icon(Icons.menu))
        ],
      ) ,
      body:ListView.builder( 
        itemCount: _messages.length, 
        itemBuilder: (context, index) { 
          return Padding( 
            padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0), 
            child: Align( 
              alignment: index % 2 == 0 ? Alignment.centerRight : Alignment.centerLeft, 
              child: Container( 
                padding: const EdgeInsets.all(12.0), 
                decoration: BoxDecoration( 
                  color: index % 2 == 0 ? const Color.fromARGB(255, 229, 95, 140) : const Color.fromARGB(90, 59, 60, 59), 
                  borderRadius:index % 2 == 0 ?
                      const BorderRadius.only(
                        bottomLeft:Radius.circular(20),
                        topLeft: Radius.circular(20),
                        bottomRight:Radius.circular(20),
                        topRight:Radius.circular(5)
                      )  :
                      const BorderRadius.only(
                        topRight:Radius.circular(15),
                        bottomRight:Radius.circular(15),
                        topLeft: Radius.circular(5),
                        bottomLeft:Radius.circular(5)
                      ), 
                ), 
                child: Text( 
                  _messages[index], 
                  style: const TextStyle(color: Colors.white), 
                ), 
              ), 
            ), 
          ); 
        }, 
      ),
      bottomNavigationBar:Row(
        mainAxisAlignment:MainAxisAlignment.start,
        crossAxisAlignment:CrossAxisAlignment.center,
        children:getChatInput(),
      ),
    );
    

  } 
}