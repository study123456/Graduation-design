//
//  KWConst.swift
//  OWhy
//
//  Created by Mr.Hu on 2020/9/18.
//  Copyright © 2020 hu. All rights reserved.
//

import UIKit

let kScreenWidth = UIScreen.main.bounds.width
let kScreenHeight = UIScreen.main.bounds.height

let kTabbarHeight : CGFloat = 49

var kNavigationBarHeight : CGFloat{
    get{
        if kScreenHeight == 812 || kScreenHeight == 896{//iPhoheX高度
            return 88
        }else{
            return 64
        }
    }
}

var kSafeAreaBottomHeight :CGFloat = (kScreenWidth == 812.0 || kScreenWidth == 896.0 ) ? 34:0


var kIsPhoneXAll : Bool  = (kScreenWidth == 812.0 || kScreenWidth == 896.0)


let kStatusBarHeight : CGFloat = 20


let kColor = UIColor(red: 56/255, green: 126/255, blue: 255/255, alpha: 1)

let kLineColor = UIColor(red: 229/255, green: 229/255, blue: 229/255, alpha: 1)

///api/v1/persons/information/basic

//if ([KWFileManager getToken].length > 0) {
//    [_manager.requestSerializer setValue: [KWFileManager getToken] forHTTPHeaderField:@"X-Authorization"];
//}
//[_manager.requestSerializer setValue:@"XMLHttpRequest" forHTTPHeaderField:@"X-Requested-With"];
//[_manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
//_manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/JavaScript", @"text/html", @"text/plain", nil];


// MARK:- 自定义打印方法
func OWFLog<T>(_ message : T, file : String = #file, funcName : String = #function, lineNum : Int = #line) {
    
    #if DEBUG
        
        let fileName = (file as NSString).lastPathComponent
        
        print("\(fileName):(\(lineNum))-\(message)")
        
    #endif
}
