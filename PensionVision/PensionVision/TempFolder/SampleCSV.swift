//
//  SampleCSV.swift
//  PensionVision
//
//  Created by Krystal D on 24/10/2025.
//

import Foundation

enum SampleCSV {
    static func sample() -> String {
        let header = "nis,first_name,last_name,dob,email,employer,date,eeamt,eramt,investment,units,nav\n"
        let rows = [
            "10001,Krystal,Dowell,1994-07-26,krystal_nd@hotmail.com,ABC Corporation,2025-01-01,100,100,growth,20,10",
            "10001,Krystal,Dowell,1994-07-26,krystal_nd@hotmail.com,ABC Corporation,2025-02-01,100,100,growth,19.90049751,10.05",
            "10001,Krystal,Dowell,1994-07-26,krystal_nd@hotmail.com,ABC Corporation,2025-03-01,100,100,growth,19.8019802,10.10",
            "10001,Krystal,Dowell,1994-07-26,krystal_nd@hotmail.com,ABC Corporation,2025-04-01,100,100,growth,19.7044335,10.15",
            "10001,Krystal,Dowell,1994-07-26,krystal_nd@hotmail.com,ABC Corporation,2025-05-01,100,100,growth,19.60784314,10.20",
            "10001,Krystal,Dowell,1994-07-26,krystal_nd@hotmail.com,ABC Corporation,2025-06-30,100,100,growth,19.51219512,10.25",
            "10001,Krystal,Dowell,1994-07-26,krystal_nd@hotmail.com,ABC Corporation,2025-07-30,100,100,growth,19.41747573,10.30",
            "10001,Krystal,Dowell,1994-07-26,krystal_nd@hotmail.com,ABC Corporation,2025-08-30,100,100,growth,19.3236715,10.35",
            "10001,Krystal,Dowell,1994-07-26,krystal_nd@hotmail.com,ABC Corporation,2025-09-30,100,100,growth,19.23076923,10.40",
            "10001,Krystal,Dowell,1994-07-26,krystal_nd@hotmail.com,ABC Corporation,2025-10-30,100,100,growth,19.13875598,10.45",
            "10001,Krystal,Dowell,1994-07-26,krystal_nd@hotmail.com,ABC Corporation,2025-11-30,100,100,growth,19.04761905,10.50",
            "10001,Krystal,Dowell,1994-07-26,krystal_nd@hotmail.com,ABC Corporation,2025-12-30,100,100,growth,18.95734597,10.55",
            "10002,Kat,Johnson,1990-09-23,kat_jd@hotmail.com,Huyo Inc,2025-01-01,100,100,balance,19.96007984,10.02",
            "10002,Kat,Johnson,1990-09-23,kat_jd@hotmail.com,Huyo Inc,2025-02-01,100,100,balance,19.92031873,10.04",
            "10002,Kat,Johnson,1990-09-23,kat_jd@hotmail.com,Huyo Inc,2025-03-01,100,100,balance,19.88071571,10.06",
            "10002,Kat,Johnson,1990-09-23,kat_jd@hotmail.com,Huyo Inc,2025-04-01,100,100,balance,19.84126984,10.08",
            "10002,Kat,Johnson,1990-09-23,kat_jd@hotmail.com,Huyo Inc,2025-05-01,100,100,balance,19.8019802,10.10",
            "10002,Kat,Johnson,1990-09-23,kat_jd@hotmail.com,Huyo Inc,2025-06-01,100,100,balance,19.76284585,10.12",
            "10002,Kat,Johnson,1990-09-23,kat_jd@hotmail.com,Huyo Inc,2025-07-01,100,100,balance,19.72386588,10.14",
            "10002,Kat,Johnson,1990-09-23,kat_jd@hotmail.com,Huyo Inc,2025-08-01,100,100,balance,19.68503937,10.16",
            "10002,Kat,Johnson,1990-09-23,kat_jd@hotmail.com,Huyo Inc,2025-09-01,100,100,balance,19.64636542,10.18",
            "10002,Kat,Johnson,1990-09-23,kat_jd@hotmail.com,Huyo Inc,2025-10-01,100,100,balance,19.60784314,10.20",
            "10002,Kat,Johnson,1990-09-23,kat_jd@hotmail.com,Huyo Inc,2025-11-01,100,100,balance,19.56947162,10.22",
            "10002,Kat,Johnson,1990-09-23,kat_jd@hotmail.com,Huyo Inc,2025-12-01,100,100,balance,19.53125,10.24",
            "10003,Theo,Taro,1996-06-03,Theo_TarTar@hotmail.com,Bubble Tea Ltd,2025-01-01,200,200,steady,39.96003996004,10.01",
            "10003,Theo,Taro,1996-06-03,Theo_TarTar@hotmail.com,Bubble Tea Ltd,2025-02-01,200,200,steady,39.92015968,10.02",
            "10003,Theo,Taro,1996-06-03,Theo_TarTar@hotmail.com,Bubble Tea Ltd,2025-03-01,200,200,steady,39.8803589232303,10.03",
            "10003,Theo,Taro,1996-06-03,Theo_TarTar@hotmail.com,Bubble Tea Ltd,2025-04-01,200,200,steady,39.8406374501992,10.04",
            "10003,Theo,Taro,1996-06-03,Theo_TarTar@hotmail.com,Bubble Tea Ltd,2025-05-01,200,200,steady,39.8009950248756,10.05",
            "10003,Theo,Taro,1996-06-03,Theo_TarTar@hotmail.com,Bubble Tea Ltd,2025-06-01,200,200,steady,39.7614314115308,10.06",
            "10003,Theo,Taro,1996-06-03,Theo_TarTar@hotmail.com,Bubble Tea Ltd,2025-07-01,200,200,steady,39.7219463753724,10.07",
            "10003,Theo,Taro,1996-06-03,Theo_TarTar@hotmail.com,Bubble Tea Ltd,2025-08-01,200,200,steady,39.6825396825397,10.08",
            "10003,Theo,Taro,1996-06-03,Theo_TarTar@hotmail.com,Bubble Tea Ltd,2025-09-01,200,200,steady,39.6432111000991,10.09",
            "10003,Theo,Taro,1996-06-03,Theo_TarTar@hotmail.com,Bubble Tea Ltd,2025-10-01,200,200,steady,39.6039603960396,10.10",
            "10003,Theo,Taro,1996-06-03,Theo_TarTar@hotmail.com,Bubble Tea Ltd,2025-11-01,200,200,steady,39.5647873392681,10.11",
            "10003,Theo,Taro,1996-06-03,Theo_TarTar@hotmail.com,Bubble Tea Ltd,2025-12-01,200,200,steady,39.5256916996047,10.12"
        ].joined(separator: "\n")
        return header + rows + "\n"
    }
}
