import 'package:finance/Public/styles.dart';
import 'package:finance/UI/Componenets/General/txt.dart';
import 'package:finance/UI/Componenets/btn.dart';
import 'package:finance/UI/Componenets/dropDown/drop-down-item.dart';
import 'package:finance/UI/Componenets/dropDown/drop-down.dart';
import 'package:finance/UI/Componenets/form/checkbox-form.dart';
import 'package:finance/UI/Componenets/form/dataList-form.dart';
import 'package:finance/UI/Componenets/form/file-form.dart';
import 'package:finance/UI/Componenets/form/input-form.dart';
import 'package:finance/UI/Componenets/form/input-group-form.dart';
import 'package:finance/UI/Componenets/form/range-form.dart';
import 'package:finance/UI/Componenets/form/select-form.dart';
import 'package:finance/UI/Componenets/form/switch-form.dart';
import 'package:finance/UI/Componenets/form/switch-box.dart';
import 'package:flutter/material.dart';
import 'form/color-form.dart';
import 'form/radioButton-form.dart';


class MyFormPage extends StatefulWidget {
  const MyFormPage({super.key});

  @override
  State<MyFormPage> createState() => _MyFormPageState();
}

class _MyFormPageState extends State<MyFormPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();


  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InputForm(lableText: 'Email Address', keyBoardType: keyboardType.email , disabled: true),
          const SizedBox(height: 15),
          InputForm(lableText: 'Password', keyBoardType: keyboardType.password , formText: 'Must be 8-20 characters long.'),
          const SizedBox(height: 15),
          CheckBoxForm(text: 'Check me out' , disabled: true),
          const SizedBox(height: 15),
          InputForm(lableText: 'Example textarea', rows: 3 , fieldType: FieldType.textarea),
          // دکمه Submit
          Btn(type: btnType.primary,content: Txt('submit'),onClick: (){
            if (_formKey.currentState!.validate()) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Processing Data')),
              );
            }
          } ,),
          const SizedBox(height: 40),
          InputForm(lableText: 'Password',hintText: 'aaaaaaaaa', keyBoardType: keyboardType.password , ),
          const SizedBox(height: 15),
          InputForm(formText: 'Must be 8-20 characters long.', keyBoardType: keyboardType.password  , layoutDirection: direction.horizontal),
          const SizedBox(height: 15),
          FileForm(),
          const SizedBox(height: 15),
          ColorPickerBox(selectedColor: Colors.blue),
          const SizedBox(height: 15),
          DataListInput(options: ['aaaaaa' , 'vvvvv' , 'kkkk'] , label: 'xxxx' , ),
          const SizedBox(height: 15),
          CustomSelect(

            hintText: 'Open this select menu',
            items: const [
              DropdownMenuItem(value: '1', child: Text('One')),
              DropdownMenuItem(value: '2', child: Text('Two')),
              DropdownMenuItem(value: '3', child: Text('Three')),
            ],
            onChanged: (value) {
              setState(() {

              });
            },
            size: InputSize.large,

          ),
          const SizedBox(height: 15),
          CheckBoxForm(text: 'Check me out' , checked: true , disabled: true,),
          const SizedBox(height: 15),
          SwitchBox(disabled: true,checked: true,label: 'disable checekd',),
          const SizedBox(height: 15),
          SwitchBox(checked: true,label: 'checked'),
          const SizedBox(height: 15),
          SwitchBox(disabled: true,label: 'disable',),
          const SizedBox(height: 15),
          SwitchBox(label: 'default',),
          const SizedBox(height: 30),
          RadioButton(items: [RadioItem(text: 'item 1'  , ) , RadioItem(text: 'item 2' , disabled: true)],onChanged: (d){}),
          const SizedBox(height: 30),
          CustomRangeSlider(
            label: "Example range",
            min: 0,
            max: 100,
            step: 5,
            onChanged: (value) {
            },
          ),
          const SizedBox(height: 30),




          //input group
          // InputGroup(isShowEnd: true , inputs: [InputForm(hintText: 'نام',),],icons: [Txt('@' , fontSize:14 ,)],isShowStart: true,),
          // const SizedBox(height: 30),
          // InputGroup(isShowEnd: true, inputs: [InputForm(hintText: 'نام', borderRadius: BorderRadius.only(topRight: Radius.circular(5), bottomRight: Radius.circular(5)),),],icons: [Txt('@' , fontSize:14 ,)], size: InputSize.small),
          // const SizedBox(height: 30),
          // InputGroup(isShowEnd: true, inputs: [InputForm(hintText: 'نام', borderRadius: BorderRadius.only(topRight: Radius.circular(5), bottomRight: Radius.circular(5)),),], icons: [ Txt('@' , fontSize:14 ,)] ,size: InputSize.large),
          // const SizedBox(height: 30),
          // InputGroup(isShowEnd: true , inputs: [InputForm(hintText: 'نام',borderRadius: BorderRadius.only(topRight: Radius.circular(5), bottomRight: Radius.circular(5)),),],icons: [Center(
          //     child: RadioButton(items: [RadioItem(text: '')],))]),
          // const SizedBox(height: 30),
          // InputGroup(isShowStart: true ,inputs: [InputForm(hintText: 'نام',borderRadius: BorderRadius.only(topLeft: Radius.circular(5), bottomLeft: Radius.circular(5))),],icons: [CheckBoxForm()]),
          // const SizedBox(height: 30),
          // InputGroup(isShowStart: true,inputs: [InputForm(hintText: 'نام',), InputForm(hintText: 'نام خانوادگی',), InputForm(hintText: 'سن',borderRadius: BorderRadius.only(topLeft: Radius.circular(5), bottomLeft: Radius.circular(5))),],icons: [ Txt('@' , fontSize:14 ,)]),
          // const SizedBox(height: 30),
          // InputGroup(isShowEnd: true,inputs: [InputForm(hintText: 'نام',borderRadius: BorderRadius.only(topRight: Radius.circular(5), bottomRight: Radius.circular(5)))],icons: [Txt('@' , fontSize:14 ,) , Txt('0.00' , fontSize:14 ,)]),
          // const SizedBox(height: 30),
          // InputGroup(isShowStart: true,inputs: [InputForm(hintText: 'نام',borderRadius: BorderRadius.only(topLeft: Radius.circular(5), bottomLeft: Radius.circular(5)))],icons: [Btn(type: btnType.secondary,content: Center(child: Txt('button')),borderRadius: BorderRadius.only(topRight: Radius.circular(5), bottomRight:Radius.circular(5) ),)]),
          // const SizedBox(height: 30),
          // InputGroup(isShowStart: true, inputs: [InputForm(hintText: 'نام',borderRadius: BorderRadius.only(topLeft: Radius.circular(5), bottomLeft: Radius.circular(5)))],
          //   icons: [Dropdown(type: btnType.secondary,dropDownTitle: 'DropDown',itemsDropDown: [
          //       DropdownItem(text: "Action"),
          //       DropdownItem(text: "Another action"),
          //       DropdownItem(text: "Something else here"),
          //     ],spreadLinkList:['spread link'],dropDownTitelColor: Colors.grey , borderRadius: BorderRadius.only(topRight: Radius.circular(5), bottomRight:Radius.circular(5) )),],),
          // const SizedBox(height: 30),
          // InputGroup(isShowStart: true, inputs: [InputForm(hintText: 'نام',borderRadius: BorderRadius.only(topLeft: Radius.circular(5), bottomLeft: Radius.circular(5)))], icons: [Dropdown(type: btnType.secondary,isSplitButton: true,dropDownTitle: 'DropDown',itemsDropDown: [
          //   DropdownItem(text: "Action"),
          //   DropdownItem(text: "Another action"),
          //   DropdownItem(text: "Something else here"),
          // ],spreadLinkList:['spread link'],dropDownTitelColor: Colors.grey, ),],),
          // const SizedBox(height: 30),
          // InputGroup(isShowStart: true , isSelectBox: true, selectList: [
          //   CustomSelect(hintText: 'choose...',
          //     borderRadius: BorderRadius.only(topLeft: Radius.circular(5), bottomLeft: Radius.circular(5)),
          //     onChanged: (value) {
          //       setState(() {
          //
          //       });
          //     },
          //     items: const [
          //   DropdownMenuItem(value: '1', child: Text('One')),
          //   DropdownMenuItem(value: '2', child: Text('Two')),
          //   DropdownMenuItem(value: '3', child: Text('Three')),
          //
          // ],)],icons: [Btn(type: btnType.secondary,content: Center(child: Txt('button')),borderRadius: BorderRadius.only(topRight: Radius.circular(5), bottomRight:Radius.circular(5) ),)]),
          // const SizedBox(height: 30),
          // InputGroup(isShowStart: true,isFileBox: true,fileList: [FileForm(borderRadius: BorderRadius.all(Radius.circular(0)),)],icons: [Txt('Upload' , fontSize:14 ,)],),
          // const SizedBox(height: 30),
          InputGroup(
            inputs: [
              InputForm(
                hintText: 'Username',
                borderColor: Colors.grey,
                borderRadius: BorderRadius.only(topRight: Radius.circular(5),bottomRight:Radius.circular(5) , ),
              ),
              Txt('@', fontSize: 16),
              InputForm(
                hintText: 'Server',
                borderColor: Colors.grey,
                borderRadius: BorderRadius.only(topLeft: Radius.circular(5),bottomLeft:Radius.circular(5) , ),
              ),
            ],
          )
          //end input group
        ],
      ),
    );
  }
}