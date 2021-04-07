import 'package:fluro/fluro.dart';
import 'package:firebase/firebase.dart' as fb;

import '../models/version.dart';

Version appVersion = new Version("1.5.3+1");
String appStatus = "";
String appFull = "Version ${appVersion.toString()}";

final router = new FluroRouter();

final String DEFAULT_PROFILE = "https://firebasestorage.googleapis.com/v0/b/bk1031-tv.appspot.com/o/default-profile.png?alt=media&token=4852e319-0b91-4512-a886-17b50033b7e1";

String appLegal = """
MIT License
Copyright (c) 2020 Bharat Kathi
Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:
The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.
THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
""";