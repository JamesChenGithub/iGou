//
//  OBDConstHelper.m
//  CarOnline
//
//  Created by James on 14-9-1.
//  Copyright (c) 2014年 James Chen. All rights reserved.
//

#if kIncludeOBDConstHelper

#import "OBDConstHelper.h"



@implementation OBDConstHelper

+ (NSMutableArray *)changeCodeToName:(NSString *)code
{
    NSMutableArray *dataStreamStrList = [NSMutableArray array];
    if(![NSString isEmpty:code])
    {
        NSArray *strArray = [code componentsSeparatedByString:@","];
        
        int pid = 0;//第一个参数
//        String[] str = new String[4];//第二个参数
        NSMutableArray *str = [NSMutableArray arrayWithCapacity:4];
        int order = 0;
        BOOL iscn = [AppDelegate sharedAppDelegate].isChinese;
        for(int i = 0; i< strArray.count; i++)
        {
            if(i % 5 == 0)
            {
                pid = ((NSString *)strArray[i]).intValue;
                order = 0;
            }
            else
            {
                str[order] = strArray[i];
                if(str.count == 4)
                {
                    NSString *result = iscn ? [OBDConstHelper cnPid:pid toName:str] : [OBDConstHelper enPid:pid toName:str];
                    if(![NSString isEmpty:result])
                    {
                        KeyValue *kv = [[KeyValue alloc] initWithKey:[NSString stringWithFormat:@"%d", pid] value:result];
                        [dataStreamStrList addObject:kv];
                    }
                    
                    str = [NSMutableArray arrayWithCapacity:4];
                }
                order++;
                
            }
        }
        
    }
    return dataStreamStrList;
}

+ (NSString *)intToBinaryString:(int)aNum
{
    NSMutableString *binStr = [NSMutableString stringWithString:@""];
    int index = 0;
    int i = 0;
    int N = 32; // sizeof(int);
    
    index = 1 << 31;
    BOOL hasFindHead = NO;
    for (i = 0; i < N; i++)
    {
        if ((aNum & index) == 0)
        {
            if (hasFindHead)
            {
                [binStr appendString:@"0"];
            }
        }
        else
        {
            hasFindHead = YES;
            [binStr appendString:@"1"];
        }
        
        index >>= 1;                          //将index值循环右移
    }
    
    
    return binStr;
}

//int IntegerToBinary(int number, char ret[], int ret_len)
//{
//    unsigned int index;
//    int i=0, N=sizeof(int)*CHAR_BIT;          //获取int类型的位数, CHAR_BIT为limit.h定义的宏，为CHAR的位数
//    if (ret_len < N)
//    {
//        return 0;
//    }
//    index = 1<<(N-1);                         //将1循环左移N-1次
//    for (i=0; i<N; ++i)
//    {
//        ret[i] = ((number&index)==0)?'0':'1'; //将需要求值的整型数与index按位相“与”，从最高位起判断是否为1
//        index >>= 1;                          //将index值循环右移
//    }
//    return 1;
//}

/**
 * 最新版
 * @param pid
 * @param array
 * @return
 * update time : 2014-07-30 by GA
 */
+(NSString *)cnPid:(int)pid toName:(NSArray *)array
{
    NSString *s0 = array[0];
    NSString *s1 = array[1];
    NSString *s2 = array[2];
    NSString *s3 = array[3];
    
    int v0 = s0.intValue << 24;
    int v1 = s1.intValue << 16;
    int v2 = s2.intValue << 8;
    int v3 = s3.intValue;
    
    int vall = (v0 + v1 + v2 +v3);
    int vper = vall/100;
    float vflo = ((int)(v0 + v1 + v2 + s3.doubleValue)*100.0 + 0.5)/10000.0;
    float vflo2 = ((int)(v0 + v1 + v2 + s3.doubleValue)*100.0 + 0.5)/10000.0;
    
    switch (pid)
    {
        case 1:
            return [NSString stringWithFormat:@"故障码个数：%d", s0.intValue];
        case 2:
            return [NSString stringWithFormat:@"动力负荷计算值：%d％", vper];
        case 3:
            return [NSString stringWithFormat:@"发动机冷却温度：%d℃", vper];
        case 4:
            return [NSString stringWithFormat:@"燃油压力：%dkPa", vper];
        case 5:
            return [NSString stringWithFormat:@"进气歧管绝对压力：%dkPa", vper];
        case 12:
            // TODO:
            return [NSString stringWithFormat:@"发动机转速：%0.2frpm", (s0.doubleValue * 256 + s1.doubleValue)/4];
            //            return "发动机转速：" + Constants.round(((Double.parseDouble(_ar[0]) * 256 + Double.parseDouble(_ar[1])) / 4), 2, BigDecimal.ROUND_DOWN)+ "rpm";
        case 13:
            return [NSString stringWithFormat:@"车速：%dkm/h", s0.intValue];
        case 8:
            // TODO:
            return [NSString stringWithFormat:@"点火正时提前角 #1缸：%0.1f°", (v0 + v1 + v2 + s3.doubleValue)/100];
            //            return "点火正时提前角 #1缸：" + Constants.round(((Integer.parseInt(_ar[0])<<24)+(Integer.parseInt(_ar[1])<<16)+(Integer.parseInt(_ar[2])<<8)+(Double.parseDouble(_ar[3])))/100,1,BigDecimal.ROUND_DOWN)+ "°";
        case 9:
            return [NSString stringWithFormat:@"进气温度：%d℃", vper];
            //            return "进气温度：" + ((Integer.parseInt(_ar[0])<<24)+(Integer.parseInt(_ar[1])<<16)+(Integer.parseInt(_ar[2])<<8)+(Integer.parseInt(_ar[3])))/100+ "℃";
        case 10:
            // TODO:
            return [NSString stringWithFormat:@"空气流量：%0.2fg/s", (v0 + v1 + v2 + s3.doubleValue)/100 ];
            //            return "空气流量：" + Constants.round(((Integer.parseInt(_ar[0])<<24)+(Integer.parseInt(_ar[1])<<16)+(Integer.parseInt(_ar[2])<<8)+(Double.parseDouble(_ar[3])))/100,2,BigDecimal.ROUND_DOWN)+ "g/s";
        case 11:
            return [NSString stringWithFormat:@"节气门绝对位置：%d ％", vper];
            //            return "节气门绝对位置：" + ((Integer.parseInt(_ar[0])<<24)+(Integer.parseInt(_ar[1])<<16)+(Integer.parseInt(_ar[2])<<8)+(Integer.parseInt(_ar[3])))/100+ "%";
        case 6:
        {
            NSMutableString *str = [NSMutableString stringWithString:@"氧传感器位置："];
            //            String str = "氧传感器位置：";
            switch (s0.intValue) {
                case 1:
                    [str appendString:@"O2S11"];
                    break;
                case 2:
                    [str appendString:@"O2S12"];
                    break;
                case 4:
                    [str appendString:@"O2S13"];
                    break;
                case 8:
                    [str appendString:@"O2S14"];
                    break;
                case 16:
                    [str appendString:@"O2S21"];
                    break;
                case 32:
                    [str appendString:@"O2S22"];
                    break;
                case 64:
                    [str appendString:@"O2S23"];
                    break;
                case 128:
                    [str appendString:@"O2S24"];
                    break;
                default:
                    [str appendString:@"未定义"];
                    break;
            }
            return str;
        }
        case 7:
            // TODO:
            return [NSString stringWithFormat:@"氧传感器输出电压  汽缸组1-传感器1：%0.1fV", vflo];
            //            return "氧传感器输出电压  汽缸组1-传感器1：" + Constants.round(((Integer.parseInt(_ar[0])<<24)+(Integer.parseInt(_ar[1])<<16)+(Integer.parseInt(_ar[2])<<8)+(Double.parseDouble(_ar[3])))/100,3,BigDecimal.ROUND_DOWN)+ "V";
        case 14:
            // TODO:
            return [NSString stringWithFormat:@"氧传感器输出电压  汽缸组1-传感器2：%0.1fV", vflo];
            //            return "氧传感器输出电压  汽缸组1-传感器2：" + Constants.round(((Integer.parseInt(_ar[0])<<24)+(Integer.parseInt(_ar[1])<<16)+(Integer.parseInt(_ar[2])<<8)+(Double.parseDouble(_ar[3])))/100,3,BigDecimal.ROUND_DOWN)+ "V";
        case 15:
            // TODO:
            return [NSString stringWithFormat:@"氧传感器输出电压  汽缸组1-传感器3：%0.1fV", vflo];
            //            return "氧传感器输出电压  汽缸组1-传感器3：" + Constants.round(((Integer.parseInt(_ar[0])<<24)+(Integer.parseInt(_ar[1])<<16)+(Integer.parseInt(_ar[2])<<8)+(Double.parseDouble(_ar[3])))/100,3,BigDecimal.ROUND_DOWN)+ "V";
        case 16:
            // TODO:
            return [NSString stringWithFormat:@"氧传感器输出电压  汽缸组1-传感器4：%0.1fV", vflo];
            //            return "氧传感器输出电压  汽缸组1-传感器4：" + Constants.round(((Integer.parseInt(_ar[0])<<24)+(Integer.parseInt(_ar[1])<<16)+(Integer.parseInt(_ar[2])<<8)+(Double.parseDouble(_ar[3])))/100,3,BigDecimal.ROUND_DOWN)+ "V";
        case 17:
            // TODO:
            return [NSString stringWithFormat:@"氧传感器输出电压  汽缸组2-传感器1：%0.1fV", vflo];
            //            return "氧传感器输出电压  汽缸组2-传感器1：" + Constants.round(((Integer.parseInt(_ar[0])<<24)+(Integer.parseInt(_ar[1])<<16)+(Integer.parseInt(_ar[2])<<8)+(Double.parseDouble(_ar[3])))/100,3,BigDecimal.ROUND_DOWN)+ "V";
        case 18:
            // TODO:
            return [NSString stringWithFormat:@"氧传感器输出电压  汽缸组2-传感器2：%0.1fV", vflo];
            //            return "氧传感器输出电压  汽缸组2-传感器2：" + Constants.round(((Integer.parseInt(_ar[0])<<24)+(Integer.parseInt(_ar[1])<<16)+(Integer.parseInt(_ar[2])<<8)+(Double.parseDouble(_ar[3])))/100,3,BigDecimal.ROUND_DOWN)+ "V";
        case 19:
            // TODO:
            return [NSString stringWithFormat:@"氧传感器输出电压  汽缸组2-传感器3：%0.1fV", vflo];
            //            return "氧传感器输出电压  汽缸组2-传感器3：" + Constants.round(((Integer.parseInt(_ar[0])<<24)+(Integer.parseInt(_ar[1])<<16)+(Integer.parseInt(_ar[2])<<8)+(Double.parseDouble(_ar[3])))/100,3,BigDecimal.ROUND_DOWN)+ "V";
        case 20:
            // TODO:
            return [NSString stringWithFormat:@"氧传感器输出电压  汽缸组2-传感器4：%0.1fV", vflo];
            //            return "氧传感器输出电压  汽缸组2-传感器4：" + Constants.round(((Integer.parseInt(_ar[0])<<24)+(Integer.parseInt(_ar[1])<<16)+(Integer.parseInt(_ar[2])<<8)+(Double.parseDouble(_ar[3])))/100,3,BigDecimal.ROUND_DOWN)+ "V";
        case 21:
        {
            NSMutableString *str = [NSMutableString stringWithString:@"OBD类型："];
            switch (s0.intValue) {
                case 1:
                    [str appendString:@"OBDII"];
                    break;
                case 2:
                    [str appendString:@"OBD"];
                    break;
                case 3:
                    [str appendString:@"OBD&OBDII"];
                    break;
                case 4:
                    [str appendString:@"OBDI"];
                    break;
                case 5:
                    [str appendString:@"NO OBD"];
                    break;
                case 6:
                    [str appendString:@"EOBD"];
                    break;
                case 7:
                    [str appendString:@"EOBD&OBDII"];
                    break;
                case 8:
                    [str appendString:@"EOBD&OBD"];
                    break;
                case 9:
                    [str appendString:@"EOBD,OBD,OBDII"];
                    break;
                case 10:
                    [str appendString:@"JOBD"];
                    break;
                case 11:
                    [str appendString:@"JOBD&OBDII"];
                    break;
                case 12:
                    [str appendString:@"JOBD&EOBD"];
                    break;
                case 13:
                    [str appendString:@"JOBD,EOBD,OBDII"];
                    break;
                case 14:
                    [str appendString:@"EURO IVB1"];
                    break;
                case 15:
                    [str appendString:@"EURO V B2"];
                    break;
                case 16:
                    [str appendString:@"EURO C"];
                    break;
                case 17:
                    [str appendString:@"EMD"];
                    break;
                default:
                    [str appendString:@"未定义"];
                    break;
            }
            return str;
        }
            
        case 22:
            return [NSString stringWithFormat:@"发动机启动后运行时间：%dsec", vper];
            //            return "发动机启动后运行时间：" + ((Integer.parseInt(_ar[0])<<24)+(Integer.parseInt(_ar[1])<<16)+(Integer.parseInt(_ar[2])<<8)+(Integer.parseInt(_ar[3])))/100+ "sec";
        case 23:
            return [NSString stringWithFormat:@"故障灯亮后运行距离：%dkm", vper];
            //            return "故障灯亮后运行距离：" + ((Integer.parseInt(_ar[0])<<24)+(Integer.parseInt(_ar[1])<<16)+(Integer.parseInt(_ar[2])<<8)+(Integer.parseInt(_ar[3])))/100+ "km";
        case 24:
            // TODO:
            return [NSString stringWithFormat:@"真空歧管燃油压力：%0.1fkPa", vflo2];
            //            return "真空歧管燃油压力：" + Constants.round(((Integer.parseInt(_ar[0])<<24)+(Integer.parseInt(_ar[1])<<16)+(Integer.parseInt(_ar[2])<<8)+(Double.parseDouble(_ar[3])))/100,2,BigDecimal.ROUND_DOWN)+ "kPa";
        case 25:
            // TODO:
            return [NSString stringWithFormat:@"氧传感器电压 B1-S1：%0.1fV", vflo];
            //            return "氧传感器电压 B1-S1：" + Constants.round(((Integer.parseInt(_ar[0])<<24)+(Integer.parseInt(_ar[1])<<16)+(Integer.parseInt(_ar[2])<<8)+(Double.parseDouble(_ar[3])))/100,3,BigDecimal.ROUND_DOWN)+ "V";
        case 26:
            // TODO:
            return [NSString stringWithFormat:@"氧传感器电压 B1-S2：%0.1fV", vflo];
            //            return "氧传感器电压 B1-S2：" + Constants.round(((Integer.parseInt(_ar[0])<<24)+(Integer.parseInt(_ar[1])<<16)+(Integer.parseInt(_ar[2])<<8))+(Double.parseDouble(_ar[3])/100),3,BigDecimal.ROUND_DOWN)+ "V";
        case 27:
            // TODO:
            return [NSString stringWithFormat:@"氧传感器电压 B1-S3：%0.1fV", vflo];
            //            return "氧传感器电压 B1-S3：" + Constants.round(((Integer.parseInt(_ar[0])<<24)+(Integer.parseInt(_ar[1])<<16)+(Integer.parseInt(_ar[2])<<8)+(Double.parseDouble(_ar[3])))/100,3,BigDecimal.ROUND_DOWN)+ "V";
        case 28:
            // TODO:
            return [NSString stringWithFormat:@"氧传感器电压 B1-S4：%0.1fV", vflo];
            //            return "氧传感器电压 B1-S4：" + Constants.round(((Integer.parseInt(_ar[0])<<24)+(Integer.parseInt(_ar[1])<<16)+(Integer.parseInt(_ar[2])<<8)+(Double.parseDouble(_ar[3])))/100,3,BigDecimal.ROUND_DOWN)+ "V";
        case 29:
            // TODO:
            return [NSString stringWithFormat:@"氧传感器电压 B2-S1：%0.1fV", vflo];
            //            return "氧传感器电压 B2-S1：" + Constants.round(((Integer.parseInt(_ar[0])<<24)+(Integer.parseInt(_ar[1])<<16)+(Integer.parseInt(_ar[2])<<8)+(Double.parseDouble(_ar[3])))/100,3,BigDecimal.ROUND_DOWN)+ "V";
        case 30:
            // TODO:
            return [NSString stringWithFormat:@"氧传感器电压 B2-S2：%0.1fV", vflo];
            //            return "氧传感器电压 B2-S2：" + Constants.round(((Integer.parseInt(_ar[0])<<24)+(Integer.parseInt(_ar[1])<<16)+(Integer.parseInt(_ar[2])<<8)+(Double.parseDouble(_ar[3])))/100,3,BigDecimal.ROUND_DOWN)+ "V";
        case 31:
            // TODO:
            return [NSString stringWithFormat:@"氧传感器电压 B2-S3：%0.1fV", vflo];
            //            return "氧传感器电压 B2-S3：" + Constants.round(((Integer.parseInt(_ar[0])<<24)+(Integer.parseInt(_ar[1])<<16)+(Integer.parseInt(_ar[2])<<8)+(Double.parseDouble(_ar[3])))/100,3,BigDecimal.ROUND_DOWN)+ "V";
        case 71:
            // TODO:
            return [NSString stringWithFormat:@"氧传感器电压 B2-S4：%0.1fV", vflo];
            //            return "氧传感器电压 B2-S4：" + Constants.round(((Integer.parseInt(_ar[0])<<24)+(Integer.parseInt(_ar[1])<<16)+(Integer.parseInt(_ar[2])<<8)+(Double.parseDouble(_ar[3])))/100,3,BigDecimal.ROUND_DOWN)+ "V";
        case 33:
            // TODO:
            return [NSString stringWithFormat:@"强制EGR：%d％", vper];
            //            return "强制EGR：" + ((Integer.parseInt(_ar[0])<<24)+(Integer.parseInt(_ar[1])<<16)+(Integer.parseInt(_ar[2])<<8)+(Integer.parseInt(_ar[3])))/100+ "%";
        case 34:
            // TODO:
            return [NSString stringWithFormat:@"GR （废弃再循环）故障：%0.2f％", vflo2];
            //            return "EGR （废弃再循环）故障：" + Constants.round(((Integer.parseInt(_ar[0])<<24)+(Integer.parseInt(_ar[1])<<16)+(Integer.parseInt(_ar[2])<<8)+(Double.parseDouble(_ar[3])))/100,2,BigDecimal.ROUND_DOWN)+ "%";
        case 35:
            return [NSString stringWithFormat:@"强制蒸发净化：%d％", vper];
            //            return "强制蒸发净化：" + ((Integer.parseInt(_ar[0])<<24)+(Integer.parseInt(_ar[1])<<16)+(Integer.parseInt(_ar[2])<<8)+(Integer.parseInt(_ar[3])))/100+ "%";
        case 36:
            return [NSString stringWithFormat:@"燃油液位输入：%d％", vper];
            //            return "燃油液位输入：" + ((Integer.parseInt(_ar[0])<<24)+(Integer.parseInt(_ar[1])<<16)+(Integer.parseInt(_ar[2])<<8)+(Integer.parseInt(_ar[3])))/100+ "%";
        case 37:
            return [NSString stringWithFormat:@"清除故障代码后暖机次数：%d", vper];
            //            return "清除故障代码后暖机次数：" + ((Integer.parseInt(_ar[0])<<24)+(Integer.parseInt(_ar[1])<<16)+(Integer.parseInt(_ar[2])<<8)+(Integer.parseInt(_ar[3])))/100;
        case 38:
            return [NSString stringWithFormat:@"清除故障代码后的距离：%dkm", vper];
            //            return "清除故障代码后的距离：" + ((Integer.parseInt(_ar[0])<<24)+(Integer.parseInt(_ar[1])<<16)+(Integer.parseInt(_ar[2])<<8)+(Integer.parseInt(_ar[3])))/100+ "km";
        case 39:
            return [NSString stringWithFormat:@"蒸发系统蒸汽压力：%dPa", vper];
            //            return "蒸发系统蒸汽压力：" + ((Integer.parseInt(_ar[0])<<24)+(Integer.parseInt(_ar[1])<<16)+(Integer.parseInt(_ar[2])<<8)+(Integer.parseInt(_ar[3])))/100+ "Pa";
        case 40:
            return [NSString stringWithFormat:@"大气压力：%dkPa", vper];
            //            return "大气压力：" + ((Integer.parseInt(_ar[0])<<24)+(Integer.parseInt(_ar[1])<<16)+(Integer.parseInt(_ar[2])<<8)+(Integer.parseInt(_ar[3])))/100+ "kPa";
        case 41:
            // TODO:
            return [NSString stringWithFormat:@"氧传感器电流 B1-S1：%0.2fmA", vflo2];
            //            return "氧传感器电流 B1-S1：" + Constants.round(((Integer.parseInt(_ar[0])<<24)+(Integer.parseInt(_ar[1])<<16)+(Integer.parseInt(_ar[2])<<8)+(Double.parseDouble(_ar[3])))/100,2,BigDecimal.ROUND_DOWN)+ "mA";
        case 42:
            // TODO:
            return [NSString stringWithFormat:@"氧传感器电流 B1-S2：%0.2fmA", vflo2];
            //            return "氧传感器电流 B1-S2：" + Constants.round(((Integer.parseInt(_ar[0])<<24)+(Integer.parseInt(_ar[1])<<16)+(Integer.parseInt(_ar[2])<<8)+(Double.parseDouble(_ar[3])))/100,2,BigDecimal.ROUND_DOWN)+ "mA";
        case 43:
            // TODO:
            return [NSString stringWithFormat:@"氧传感器电流 B1-S3：%0.2fmA", vflo2];
            //            return "氧传感器电流 B1-S3：" + Constants.round(((Integer.parseInt(_ar[0])<<24)+(Integer.parseInt(_ar[1])<<16)+(Integer.parseInt(_ar[2])<<8)+(Double.parseDouble(_ar[3])))/100,2,BigDecimal.ROUND_DOWN)+ "mA";
        case 44:
            // TODO:
            return [NSString stringWithFormat:@"氧传感器电流 B1-S4：%0.2fmA", vflo2];
            //            return "氧传感器电流(mA) B1-S4：" + Constants.round(((Integer.parseInt(_ar[0])<<24)+(Integer.parseInt(_ar[1])<<16)+(Integer.parseInt(_ar[2])<<8)+(Double.parseDouble(_ar[3])))/100,2,BigDecimal.ROUND_DOWN)+ "mA";
        case 45:
            // TODO:
            return [NSString stringWithFormat:@"氧传感器电流 B2-S1：%0.2fmA", vflo2];
            //            return "氧传感器电流 B2-S1：" + Constants.round(((Integer.parseInt(_ar[0])<<24)+(Integer.parseInt(_ar[1])<<16)+(Integer.parseInt(_ar[2])<<8)+(Double.parseDouble(_ar[3])))/100,2,BigDecimal.ROUND_DOWN)+ "mA";
        case 46:
            // TODO:
            return [NSString stringWithFormat:@"氧传感器电流 B2-S2：%0.2fmA", vflo2];
            //            return "氧传感器电流 B2-S2：" + Constants.round(((Integer.parseInt(_ar[0])<<24)+(Integer.parseInt(_ar[1])<<16)+(Integer.parseInt(_ar[2])<<8)+(Double.parseDouble(_ar[3])))/100,2,BigDecimal.ROUND_DOWN)+ "mA";
        case 47:
            // TODO:
            return [NSString stringWithFormat:@"氧传感器电流 B2-S3：%0.2fmA", vflo2];
            //            return "氧传感器电流 B2-S3：" + Constants.round(((Integer.parseInt(_ar[0])<<24)+(Integer.parseInt(_ar[1])<<16)+(Integer.parseInt(_ar[2])<<8)+(Double.parseDouble(_ar[3])))/100,2,BigDecimal.ROUND_DOWN)+ "mA";
        case 48:
            // TODO
            return [NSString stringWithFormat:@"氧传感器电流 B2-S4：%0.2fmA", vflo2];
            //            return "氧传感器电流 B2-S4：" + Constants.round(((Integer.parseInt(_ar[0])<<24)+(Integer.parseInt(_ar[1])<<16)+(Integer.parseInt(_ar[2])<<8)+(Double.parseDouble(_ar[3])))/100,2,BigDecimal.ROUND_DOWN)+ "mA";
        case 49:
            // TODO
            return [NSString stringWithFormat:@"催化剂温度 B1-S1：%0.1f℃", vflo];
            //            return "催化剂温度 B1-S1：" + Constants.round(((Integer.parseInt(_ar[0])<<24)+(Integer.parseInt(_ar[1])<<16)+(Integer.parseInt(_ar[2])<<8)+(Double.parseDouble(_ar[3])))/100,1,BigDecimal.ROUND_DOWN)+ "℃";
        case 50:
            // TODO
            return [NSString stringWithFormat:@"催化剂温度 B2-S1：%0.1f℃", vflo];
            //            return "催化剂温度 B2-S1：" + Constants.round(((Integer.parseInt(_ar[0])<<24)+(Integer.parseInt(_ar[1])<<16)+(Integer.parseInt(_ar[2])<<8)+(Double.parseDouble(_ar[3])))/100,1,BigDecimal.ROUND_DOWN)+ "℃";
        case 51:
            // TODO
            return [NSString stringWithFormat:@"催化剂温度 B1-S2：%0.1f℃", vflo];
            //            return "催化剂温度 B1-S2：" + Constants.round(((Integer.parseInt(_ar[0])<<24)+(Integer.parseInt(_ar[1])<<16)+(Integer.parseInt(_ar[2])<<8)+(Double.parseDouble(_ar[3])))/100,1,BigDecimal.ROUND_DOWN)+ "℃";
        case 52:
            // TODO
            return [NSString stringWithFormat:@"催化剂温度 B2-S2：%0.1f℃", vflo];
            //            return "催化剂温度 B2-S2：" + Constants.round(((Integer.parseInt(_ar[0])<<24)+(Integer.parseInt(_ar[1])<<16)+(Integer.parseInt(_ar[2])<<8)+(Double.parseDouble(_ar[3])))/100,1,BigDecimal.ROUND_DOWN)+ "℃";
        case 53:
            // TODO
            return [NSString stringWithFormat:@"大气温度：%d℃", vper];
            //            return "大气温度：" + ((Integer.parseInt(_ar[0])<<24)+(Integer.parseInt(_ar[1])<<16)+(Integer.parseInt(_ar[2])<<8)+(Integer.parseInt(_ar[3])))/100+ "℃";
        case 54:
            return [NSString stringWithFormat:@"故障灯亮后发动机运行时间：%dmin", vper];
            //            return "故障灯亮后发动机运行时间：" + ((Integer.parseInt(_ar[0])<<24)+(Integer.parseInt(_ar[1])<<16)+(Integer.parseInt(_ar[2])<<8)+(Integer.parseInt(_ar[3])))/100+ "min";
        case 55:
            return [NSString stringWithFormat:@"故障码清除后发动机运行时间：%dmin", vper];
            //            return "故障码清除后发动机运行时间：" + ((Integer.parseInt(_ar[0])<<24)+(Integer.parseInt(_ar[1])<<16)+(Integer.parseInt(_ar[2])<<8)+(Integer.parseInt(_ar[3])))/100+ "min";
        case 56:
            return [NSString stringWithFormat:@"氧传感器最大电压：%dV", vper];
            //            return "氧传感器最大电压：" + ((Integer.parseInt(_ar[0])<<24)+(Integer.parseInt(_ar[1])<<16)+(Integer.parseInt(_ar[2])<<8)+(Integer.parseInt(_ar[3])))/100+ "V";
        case 57:
            return [NSString stringWithFormat:@"氧传感器最大电流：%dmA", vper];
            //            return "氧传感器最大电流：" + ((Integer.parseInt(_ar[0])<<24)+(Integer.parseInt(_ar[1])<<16)+(Integer.parseInt(_ar[2])<<8)+(Integer.parseInt(_ar[3])))/100+ "mA";
        case 58:
            return [NSString stringWithFormat:@"氧传感器最大电流：%dg/s", vper];
            //            return "空气流量传感最大值：" + ((Integer.parseInt(_ar[0])<<24)+(Integer.parseInt(_ar[1])<<16)+(Integer.parseInt(_ar[2])<<8)+(Integer.parseInt(_ar[3])))/100 + "g/s";
        case 59:
        {
            NSMutableString *str = [NSMutableString stringWithString:@"燃油类型："];
            switch (s0.intValue) {
                case 1:
                    [str appendString:@"GAS"];
                    break;
                case 2:
                    [str appendString:@"METH"];
                    break;
                case 3:
                    [str appendString:@"ETH"];
                    break;
                case 4:
                    [str appendString:@"Diesel"];
                    break;
                case 5:
                    [str appendString:@"LPG"];
                    break;
                case 6:
                    [str appendString:@"CNG"];
                    break;
                case 7:
                    [str appendString:@"PROP"];
                    break;
                case 8:
                    [str appendString:@"ELEC"];
                    break;
                case 9:
                    [str appendString:@"BI_GAS"];
                    break;
                case 10:
                    [str appendString:@"BI_METH"];
                    break;
                case 11:
                    [str appendString:@"BI_ETH"];
                    break;
                case 12:
                    [str appendString:@"BI_METH"];
                    break;
                case 13:
                    [str appendString:@"BI_CNG"];
                    break;
                case 14:
                    [str appendString:@"BI_PROP"];
                    break;
                case 15:
                    [str appendString:@"BI_ELEC"];
                    break;
                default:
                    [str appendString:@"未定义"];
                    break;
            }
            return str;
        }
        case 60:
            // TODO
            return [NSString stringWithFormat:@"燃油压力绝对值：%0.1fkPa", vflo];
            //            return "燃油压力绝对值：" + Constants.round(((Integer.parseInt(_ar[0])<<24)+(Integer.parseInt(_ar[1])<<16)+(Integer.parseInt(_ar[2])<<8)+(Double.parseDouble(_ar[3])))/100,1,BigDecimal.ROUND_DOWN)+ "kPa";
        case 61:
            // TODO
            return [NSString stringWithFormat:@"油门塌板相对位置：%0.1f％", vflo];
            //            return "油门塌板相对位置：" + Constants.round(((Integer.parseInt(_ar[0])<<24)+(Integer.parseInt(_ar[1])<<16)+(Integer.parseInt(_ar[2])<<8)+(Double.parseDouble(_ar[3])))/100,1,BigDecimal.ROUND_DOWN)+ "%";
        case 62:
            // TODO
            return [NSString stringWithFormat:@"电池剩余电量：%0.1f％", vflo];
            //            return "电池剩余电量：" + Constants.round(((Integer.parseInt(_ar[0])<<24)+(Integer.parseInt(_ar[1])<<16)+(Integer.parseInt(_ar[2])<<8)+(Double.parseDouble(_ar[3])))/100,1,BigDecimal.ROUND_DOWN)+ "%";
        case 63:
            // TODO
            return [NSString stringWithFormat:@"发动机燃油温度：%d℃", vper];
            //            return "发动机燃油温度：" + ((Integer.parseInt(_ar[0])<<24)+(Integer.parseInt(_ar[1])<<16)+(Integer.parseInt(_ar[2])<<8)+(Integer.parseInt(_ar[3])))/100+ "℃";
        case 72:
            // TODO
            return [NSString stringWithFormat:@"燃油喷射点：%0.1f°", vflo];
            //            return "燃油喷射点：" + Constants.round(((Integer.parseInt(_ar[0])<<24)+(Integer.parseInt(_ar[1])<<16)+(Integer.parseInt(_ar[2])<<8)+(Double.parseDouble(_ar[3])))/100,3,BigDecimal.ROUND_DOWN)+ "°";
        case 65:
            // TODO
            return [NSString stringWithFormat:@"燃油喷射点：%0.2fL/h", vflo2];
            //            return "燃油消耗：" + Constants.round(((Integer.parseInt(_ar[0])<<24)+(Integer.parseInt(_ar[1])<<16)+(Integer.parseInt(_ar[2])<<8)+(Double.parseDouble(_ar[3])))/100,2,BigDecimal.ROUND_DOWN)+ "L/h";
        case 66:
        {
            NSMutableString *str = [NSMutableString stringWithFormat:@"遵循的排放标准："];
            switch (s0.intValue) {
                case 14:
                    [str appendString:@"EURO IV B1"];
                    break;
                case 15:
                    [str appendString:@"RURO V B2"];
                    break;
                case 16:
                    [str appendString:@"EURO C"];
                    break;
                default:
                    [str appendString:@"未定义"];
                    break;
            }
            return str;
        }
        case 67:
            return [NSString stringWithFormat:@"燃油温度：%d℃", vper];
            
            //            return "燃油温度：" + ((Integer.parseInt(_ar[0])<<24)+(Integer.parseInt(_ar[1])<<16)+(Integer.parseInt(_ar[2])<<8)+(Integer.parseInt(_ar[3])))/100+ "℃";
        case 68:
            return [NSString stringWithFormat:@"发动机总运行时间：%dsec", vper];
            //            return "发动机总运行时间：" + ((Integer.parseInt(_ar[0])<<24)+(Integer.parseInt(_ar[1])<<16)+(Integer.parseInt(_ar[2])<<8)+(Integer.parseInt(_ar[3])))/100+ "sec";
        case 69:
            return [NSString stringWithFormat:@"发动机总怠速时间：%dsec", vper];
            //            return "发动机总怠速时间：" + ((Integer.parseInt(_ar[0])<<24)+(Integer.parseInt(_ar[1])<<16)+(Integer.parseInt(_ar[2])<<8)+(Integer.parseInt(_ar[3])))/100+ "sec";
        case 70:
        {
            NSMutableString *str = [NSMutableString stringWithFormat:@"故障灯状态："];
            switch (s0.intValue) {
                case 0:
                    [str appendString:@"未亮"];
                    break;
                case 1:
                    [str appendString:@"亮"];
                    break;
                default:
                    [str appendString:@"未定义"];
                    break;
            }
            return str;
        }
        case 135:
            return [NSString stringWithFormat:@"发动机总运行时间：%dsec", vper];
            //            return "发动机总运行时间：" + ((Integer.parseInt(_ar[0])<<24)+(Integer.parseInt(_ar[1])<<16)+(Integer.parseInt(_ar[2])<<8)+(Integer.parseInt(_ar[3])))/100+ "sec";
        case 136:
            return [NSString stringWithFormat:@"发动机短期运行时间：%dsec", vper];
            //            return "发动机短期运行时间：" + ((Integer.parseInt(_ar[0])<<24)+(Integer.parseInt(_ar[1])<<16)+(Integer.parseInt(_ar[2])<<8)+(Integer.parseInt(_ar[3])))/100+ "sec";
        case 137:
            return [NSString stringWithFormat:@"发动机本次运行时间：%dsec", vper];
            //            return "发动机本次运行时间：" + ((Integer.parseInt(_ar[0])<<24)+(Integer.parseInt(_ar[1])<<16)+(Integer.parseInt(_ar[2])<<8)+(Integer.parseInt(_ar[3])))/100+ "sec";
        case 138:
            return [NSString stringWithFormat:@"总油耗：%dL", vper];
            //            return "总油耗：" + ((Integer.parseInt(_ar[0])<<24)+(Integer.parseInt(_ar[1])<<16)+(Integer.parseInt(_ar[2])<<8)+(Integer.parseInt(_ar[3])))/100+ "L";
        case 139:
            return [NSString stringWithFormat:@"短期油耗：%dL", vper];
            //            return "短期油耗：" + ((Integer.parseInt(_ar[0])<<24)+(Integer.parseInt(_ar[1])<<16)+(Integer.parseInt(_ar[2])<<8)+(Integer.parseInt(_ar[3])))/100+ "L";
        case 140:
            return [NSString stringWithFormat:@"本次油耗：%dL", vper];
            //            return "本次油耗：" + ((Integer.parseInt(_ar[0])<<24)+(Integer.parseInt(_ar[1])<<16)+(Integer.parseInt(_ar[2])<<8)+(Integer.parseInt(_ar[3])))/100+ "L";
        case 141:
            return [NSString stringWithFormat:@"本次油耗：%dL/100km", vper];
            //            return "总平均油耗：" + ((Integer.parseInt(_ar[0])<<24)+(Integer.parseInt(_ar[1])<<16)+(Integer.parseInt(_ar[2])<<8)+(Integer.parseInt(_ar[3])))/100+ "L/100km";
        case 142:
            return [NSString stringWithFormat:@"短期平均油耗：%dL/100km", vper];
            //            return "短期平均油耗：" + ((Integer.parseInt(_ar[0])<<24)+(Integer.parseInt(_ar[1])<<16)+(Integer.parseInt(_ar[2])<<8)+(Integer.parseInt(_ar[3])))/100+ "L/100km";
        case 143:
            return [NSString stringWithFormat:@"本次平均油耗：%dL/100km", vper];
            //            return "本次平均油耗：" + ((Integer.parseInt(_ar[0])<<24)+(Integer.parseInt(_ar[1])<<16)+(Integer.parseInt(_ar[2])<<8)+(Integer.parseInt(_ar[3])))/100+ "L/100km";
        case 144:
            return [NSString stringWithFormat:@"总费用：%d￥", vper];
            //            return "总费用：" + ((Integer.parseInt(_ar[0])<<24)+(Integer.parseInt(_ar[1])<<16)+(Integer.parseInt(_ar[2])<<8)+(Integer.parseInt(_ar[3])))/100+ "￥";
        case 145:
            return [NSString stringWithFormat:@"短期费用：%d￥", vper];
            //            return "短期费用：" + ((Integer.parseInt(_ar[0])<<24)+(Integer.parseInt(_ar[1])<<16)+(Integer.parseInt(_ar[2])<<8)+(Integer.parseInt(_ar[3])))/100+ "￥";
        case 146:
            return [NSString stringWithFormat:@"本次费用：%d￥", vper];
            //            return "本次费用：" + ((Integer.parseInt(_ar[0])<<24)+(Integer.parseInt(_ar[1])<<16)+(Integer.parseInt(_ar[2])<<8)+(Integer.parseInt(_ar[3])))/100+ "￥";
        case 147:
            return [NSString stringWithFormat:@"总里程：%dkm", vper];
            //            return "总里程：" + ((Integer.parseInt(_ar[0])<<24)+(Integer.parseInt(_ar[1])<<16)+(Integer.parseInt(_ar[2])<<8)+(Integer.parseInt(_ar[3])))/100+ "km";
        case 148:
            return [NSString stringWithFormat:@"短期里程：%dkm", vper];
            //            return "短期里程：" + ((Integer.parseInt(_ar[0])<<24)+(Integer.parseInt(_ar[1])<<16)+(Integer.parseInt(_ar[2])<<8)+(Integer.parseInt(_ar[3])))/100+ "km";
        case 149:
            return [NSString stringWithFormat:@"本次里程：%dkm", vper];
            //            return "本次里程：" + ((Integer.parseInt(_ar[0])<<24)+(Integer.parseInt(_ar[1])<<16)+(Integer.parseInt(_ar[2])<<8)+(Integer.parseInt(_ar[3])))/100+ "km";
        case 150:
            return [NSString stringWithFormat:@"瞬时油耗（按里程）：%dL/100km", vper];
            //            return "瞬时油耗（按里程）：" + ((Integer.parseInt(_ar[0])<<24)+(Integer.parseInt(_ar[1])<<16)+(Integer.parseInt(_ar[2])<<8)+(Integer.parseInt(_ar[3])))/100+ "L/100km";
        case 151:
            return [NSString stringWithFormat:@"瞬时油耗（按时间）：%dL/h", vper];
            //            return "瞬时油耗（按时间）：" + ((Integer.parseInt(_ar[0])<<24)+(Integer.parseInt(_ar[1])<<16)+(Integer.parseInt(_ar[2])<<8)+(Integer.parseInt(_ar[3])))/100+ "L/h";
		case 152:{
			NSMutableString *str = [NSMutableString stringWithFormat:@"排放："];
            switch (s0.intValue)
            {
                case 0:
                    [str appendString:@"合格"];
                    break;
                case 1:
                    [str appendString:@"不合格"];
                    break;
                default:
                    [str appendString:@"未定义"];
                    break;
            }
            
            NSString *result = [OBDConstHelper intToBinaryString:s1.intValue];
            
            //            String result = Integer.toBinaryString(Integer.parseInt(_ar[1]));
            //			try {
            if (![NSString isEmpty:result] && ![result isEqualToString:@"0"])
            {
                switch ([result substringAtRange:NSMakeRange(0, 1)].intValue) {
                    case 0:
                        [str appendString:@"催化剂正常"];
                        break;
                    case 1:
                        [str appendString:@"催化剂异常"];
                        break;
                }
                switch ([result substringAtRange:NSMakeRange(1, 1)].intValue) {
                    case 0:
                        [str appendString:@"EGR正常"];
                        break;
                    case 1:
                        [str appendString:@"EGR异常"];
                        break;
                }
                switch ([result substringAtRange:NSMakeRange(2, 1)].intValue) {
                    case 0:
                        [str appendString:@"EVAP正常"];
                        break;
                    case 1:
                        [str appendString:@"EVAP异常"];
                        break;
                }
                switch ([result substringAtRange:NSMakeRange(3, 1)].intValue) {
                    case 0:
                        [str appendString:@"泵监测正常"];
                        break;
                    case 1:
                        [str appendString:@"泵监测异常"];
                        break;
                }
                switch ([result substringAtRange:NSMakeRange(4, 1)].intValue) {
                    case 0:
                        [str appendString:@"热氧传感器组正常"];
                        break;
                    case 1:
                        [str appendString:@"热氧传感器组异常"];
                        break;
                }
                switch ([result substringAtRange:NSMakeRange(5, 1)].intValue) {
                    case 0:
                        [str appendString:@"热催化剂正常"];
                        break;
                    case 1:
                        [str appendString:@"热催化剂异常"];
                        break;
                }
                switch ([result substringAtRange:NSMakeRange(6, 1)].intValue) {
                    case 0:
                        [str appendString:@"失火未产生"];
                        break;
                    case 1:
                        [str appendString:@"失火产生"];
                        break;
                }
            }
            //			} catch (Exception e) {
            //				// TODO Auto-generated catch block
            //				e.printStackTrace();
            //			}
            return str;
		}
        case 153:
            // TODO
            return [NSString stringWithFormat:@"电池剩余电量：%0.2fV", vflo2];
            //            return "电池剩余电量：" + Constants.round(((Integer.parseInt(_ar[0])<<24)+(Integer.parseInt(_ar[1])<<16)+(Integer.parseInt(_ar[2])<<8)+(Double.parseDouble(_ar[3])))/100,2,BigDecimal.ROUND_DOWN)+ "V";
        case 170:
            // TODO
            return [NSString stringWithFormat:@"续航里程：%dkm", vper];
            //            return "续航里程：" + ((Integer.parseInt(_ar[0])<<24)+(Integer.parseInt(_ar[1])<<16)+(Integer.parseInt(_ar[2])<<8)+(Integer.parseInt(_ar[3])))/100+ "km";
        case 171:
            return [NSString stringWithFormat:@"剩余油量：%dL", vper];
            //            return "剩余油量：" + ((Integer.parseInt(_ar[0])<<24)+(Integer.parseInt(_ar[1])<<16)+(Integer.parseInt(_ar[2])<<8)+(Integer.parseInt(_ar[3])))/100+ "L";
        case 172:
            return [NSString stringWithFormat:@"续航里程：%d％", vper];
            //            return "续航里程：" + ((Integer.parseInt(_ar[0])<<24)+(Integer.parseInt(_ar[1])<<16)+(Integer.parseInt(_ar[2])<<8)+(Integer.parseInt(_ar[3])))/100+ "%";
		case 173:
        {
            NSMutableString *str = [NSMutableString stringWithString:@"手刹状态："];
            switch (s0.intValue) {
                case 0:
                    [str appendString:@"松开"];
                    break;
                case 1:
                    [str appendString:@"拉紧"];
                    break;
                default:
                    [str appendString:@"未定义"];
                    break;
            }
            return str;
        }
		case 174:
        {
            NSMutableString *str = [NSMutableString stringWithString:@"刹车状态（脚刹）："];
            //            String str = "刹车状态（脚刹）：";
            switch (s0.intValue) {
                case 0:
                    [str appendString:@"松开"];
                    break;
                case 1:
                    [str appendString:@"踏下"];
                    break;
                default:
                    [str appendString:@"未定义"];
                    break;
            }
            return str;
        }
		case 175:
        {
            NSMutableString *str = [NSMutableString stringWithString:@"安全带（驾驶员）状态："];
            //            String str = "安全带（驾驶员）状态：";
            switch (s0.intValue) {
                case 0:
                    [str appendString:@"未扣"];
                    break;
                case 1:
                    [str appendString:@"已扣"];
                    break;
                default:
                    [str appendString:@"未定义"];
                    break;
            }
            return str;
        }
		case 176:
        {
            NSMutableString *str = [NSMutableString stringWithString:@"安全带（副驾）状态："];
            //            String str = "安全带（副驾）状态：";
            switch (s0.intValue) {
                case 0:
                    [str appendString:@"未扣"];
                    break;
                case 1:
                    [str appendString:@"已扣"];
                    break;
                default:
                    [str appendString:@"未定义"];
                    break;
            }
            return str;
        }
       	case 177:
        {
            NSMutableString *str = [NSMutableString stringWithString:@"档位状态："];
            //            String str = "档位状态：";
            switch (s0.intValue) {
                case 1:
                    [str appendString:@"P"];
                    break;
                case 2:
                    [str appendString:@"R"];
                    break;
                case 3:
                    [str appendString:@"N"];
                    break;
                case 4:
                    [str appendString:@"D"];
                    break;
                default:
                    [str appendString:@"未定义"];
                    break;
            }
            return str;
        }
		case 178:
        {
            NSMutableString *str = [NSMutableString stringWithString:@"档位状态："];
            //            String str = "门状态（左前）：";
            switch (s0.intValue) {
                case 0:
                    [str appendString:@"关闭"];
                    break;
                case 1:
                    [str appendString:@"打开"];
                    break;
                default:
                    [str appendString:@"未定义"];
                    break;
            }
            return str;
        }
		case 179:
        {
            NSMutableString *str = [NSMutableString stringWithString:@"门状态（右前）："];
            //            String str = "门状态（右前）：";
            switch (s0.intValue) {
                case 0:
                    [str appendString:@"关闭"];
                    break;
                case 1:
                    [str appendString:@"打开"];
                    break;
                default:
                    [str appendString:@"未定义"];
                    break;
            }
            return str;
        }
		case 180:
        {
            NSMutableString *str = [NSMutableString stringWithString:@"门状态（左后）："];
            //            String str = "门状态（左后）：";
            switch (s0.intValue) {
                case 0:
                    [str appendString:@"关闭"];
                    break;
                case 1:
                    [str appendString:@"打开"];
                    break;
                default:
                    [str appendString:@"未定义"];
                    break;
            }
            return str;
        }
		case 181:
        {
            NSMutableString *str = [NSMutableString stringWithString:@"门状态（右后）："];
            //            String str = "门状态（右后）：";
            switch (s0.intValue) {
                case 0:
                    [str appendString:@"关闭"];
                    break;
                case 1:
                    [str appendString:@"打开"];
                    break;
                default:
                    [str appendString:@"未定义"];
                    break;
            }
            return str;
        }
		case 182:
        {
            NSMutableString *str = [NSMutableString stringWithString:@"门状态（右后）："];
            //            String str = "门状态（尾箱）：";
            switch (s0.intValue) {
                case 0:
                    [str appendString:@"关闭"];
                    break;
                case 1:
                    [str appendString:@"打开"];
                    break;
                default:
                    [str appendString:@"未定义"];
                    break;
            }
            return str;
        }
		case 183:
        {
            NSMutableString *str = [NSMutableString stringWithString:@"门锁（全车）："];
            //            String str = "门锁（全车）：";
            switch (s0.intValue) {
                case 0:
                    [str appendString:@"解锁"];
                    break;
                case 1:
                    [str appendString:@"上锁"];
                    break;
                default:
                    [str appendString:@"未定义"];
                    break;
            }
            return str;
        }
		case 184:
        {
            NSMutableString *str = [NSMutableString stringWithString:@"门锁（左前门）："];
            //            String str = "门锁（左前门）：";
            switch (s0.intValue)
            {
                case 0:
                    [str appendString:@"解锁"];
                    break;
                case 1:
                    [str appendString:@"上锁"];
                    break;
                default:
                    [str appendString:@"未定义"];
                    break;
            }
            return str;
        }
		case 185:
        {
            NSMutableString *str = [NSMutableString stringWithString:@"门锁（右前门）："];
            //            String str = "门锁（右前门）：";
            switch (s0.intValue) {
                case 0:
                    [str appendString:@"解锁"];
                    break;
                case 1:
                    [str appendString:@"上锁"];
                    break;
                default:
                    [str appendString:@"未定义"];
                    break;
            }
            return str;
        }
		case 186:
        {
            NSMutableString *str = [NSMutableString stringWithString:@"门锁（左后门）："];
            //            String str = "门锁（左后门）：";
            
            switch (s0.intValue) {
                case 0:
                    [str appendString:@"解锁"];
                    break;
                case 1:
                    [str appendString:@"上锁"];
                    break;
                default:
                    [str appendString:@"未定义"];
                    break;
            }
            return str;
        }
		case 187:
        {
            NSMutableString *str = [NSMutableString stringWithString:@"门锁（右后门）："];
            //            String str = "门锁（右后门）：";
            switch (s0.intValue) {
                case 0:
                    [str appendString:@"解锁"];
                    break;
                case 1:
                    [str appendString:@"上锁"];
                    break;
                default:
                    [str appendString:@"未定义"];
                    break;
            }
            return str;
        }
		case 188:
        {
            NSMutableString *str = [NSMutableString stringWithString:@"门锁（尾箱）："];
            //            String str = "门锁（尾箱）：";
            switch (s0.intValue) {
                case 0:
                    [str appendString:@"解锁"];
                    break;
                case 1:
                    [str appendString:@"上锁"];
                    break;
                default:
                    [str appendString:@"未定义"];
                    break;
            }
            return str;
        }
		case 189:
        {
            NSMutableString *str = [NSMutableString stringWithString:@"窗状态（左前）："];
            //            String str = "窗状态（左前）：";
            switch (s0.intValue)
            {
                case 0:
                    [str appendString:@"关闭"];
                    break;
                case 1:
                    [str appendString:@"打开"];
                    break;
                default:
                    [str appendString:@"未定义"];
                    break;
            }
            return str;
        }
		case 190:
        {
            NSMutableString *str = [NSMutableString stringWithString:@"窗状态（右前）："];
            //            String str = "窗状态（右前）：";
            switch (s0.intValue) {
                case 0:
                    [str appendString:@"关闭"];
                    break;
                case 1:
                    [str appendString:@"打开"];
                    break;
                default:
                    [str appendString:@"未定义"];
                    break;
            }
            return str;
        }
		case 191:
        {
            NSMutableString *str = [NSMutableString stringWithString:@"窗状态（左后）："];
            //            String str = "窗状态（左后）：";
            switch (s0.intValue) {
                case 0:
                    [str appendString:@"关闭"];
                    break;
                case 1:
                    [str appendString:@"打开"];
                    break;
                default:
                    [str appendString:@"未定义"];
                    break;
            }
            return str;
        }
		case 192:
        {
            NSMutableString *str = [NSMutableString stringWithString:@"窗状态（右后）："];
            //            String str = "窗状态（右后）：";
            switch (s0.intValue) {
                case 0:
                    [str appendString:@"关闭"];
                    break;
                case 1:
                    [str appendString:@"打开"];
                    break;
                default:
                    [str appendString:@"未定义"];
                    break;
            }
            return str;
        }
		case 193:
        {
            NSMutableString *str = [NSMutableString stringWithString:@"窗状态（天窗）："];
            //            String str = "窗状态（天窗）：";
            switch (s0.intValue) {
                case 0:
                    [str appendString:@"关闭"];
                    break;
                case 1:
                    [str appendString:@"打开"];
                    break;
                default:
                    [str appendString:@"未定义"];
                    break;
            }
            return str;
        }
		case 194:
        {
            NSMutableString *str = [NSMutableString stringWithString:@"灯状态（远光灯）："];
            //            String str = "灯状态（远光灯）：";
            switch (s0.intValue) {
                case 0:
                    [str appendString:@"关闭"];
                    break;
                case 1:
                    [str appendString:@"打开"];
                    break;
                default:
                    [str appendString:@"未定义"];
                    break;
            }
            return str;
        }
		case 195:
        {
            NSMutableString *str = [NSMutableString stringWithString:@"灯状态（近光灯）："];
            //            String str = "灯状态（近光灯）：";
            switch (s0.intValue)
            {
                case 0:
                    [str appendString:@"关闭"];
                    break;
                case 1:
                    [str appendString:@"打开"];
                    break;
                default:
                    [str appendString:@"未定义"];
                    break;
            }
            return str;
        }
		case 196:
        {
            NSMutableString *str = [NSMutableString stringWithString:@"灯状态（示宽灯）："];
            //            String str = "灯状态（示宽灯）：";
            switch (s0.intValue) {
                case 0:
                    [str appendString:@"关闭"];
                    break;
                case 1:
                    [str appendString:@"打开"];
                    break;
                default:
                    [str appendString:@"未定义"];
                    break;
            }
            return str;
        }
		case 197:
        {
            NSMutableString *str = [NSMutableString stringWithString:@"灯状态（雾灯）："];
            //            String str = "灯状态（雾灯）：";
            switch (s0.intValue) {
                case 0:
                    [str appendString:@"关闭"];
                    break;
                case 1:
                    [str appendString:@"打开"];
                    break;
                default:
                    [str appendString:@"未定义"];
                    break;
            }
            return str;
        }
		case 198:
        {
            NSMutableString *str = [NSMutableString stringWithString:@"灯状态（左转向）："];
            
            //            String str = "灯状态（左转向）：";
            switch (s0.intValue) {
                case 0:
                    [str appendString:@"关闭"];
                    break;
                case 1:
                    [str appendString:@"打开"];
                    break;
                default:
                    [str appendString:@"未定义"];
                    break;
            }
            return str;
        }
		case 199:
        {
            NSMutableString *str = [NSMutableString stringWithString:@"灯状态（左转向）："];
            //            String str = "灯状态（右转向）：";
            switch (s0.intValue) {
                case 0:
                    [str appendString:@"关闭"];
                    break;
                case 1:
                    [str appendString:@"打开"];
                    break;
                default:
                    [str appendString:@"未定义"];
                    break;
            }
            return str;
        }
		case 200:
        {
            NSMutableString *str = [NSMutableString stringWithString:@"灯状态（警示灯）："];
            //            String str = "灯状态（警示灯）：";
            switch (s0.intValue)
            {
                case 0:
                    [str appendString:@"关闭"];
                    break;
                case 1:
                    [str appendString:@"打开"];
                    break;
                default:
                    [str appendString:@"未定义"];
                    break;
            }
            return str;
        }
		case 201:
        {
            NSMutableString *str = [NSMutableString stringWithString:@"故障信号（ECM）："];
            //            String str = "故障信号（ECM）：";
            switch (s0.intValue) {
                case 0:
                    [str appendString:@"正常"];
                    break;
                case 1:
                    [str appendString:@"故障"];
                    break;
                default:
                    [str appendString:@"未定义"];
                    break;
            }
            return str;
        }
		case 202:
        {
            NSMutableString *str = [NSMutableString stringWithString:@"故障信号（ABS）："];
            //            String str = "故障信号（ABS）：";
            switch (s0.intValue) {
                case 0:
                    [str appendString:@"正常"];
                    break;
                case 1:
                    [str appendString:@"故障"];
                    break;
                default:
                    [str appendString:@"未定义"];
                    break;
            }
            return str;
        }
		case 203:
        {
            NSMutableString *str = [NSMutableString stringWithString:@"故障信号（SRS）："];
            //            String str = "故障信号（SRS）：";
            switch (s0.intValue) {
                case 0:
                    [str appendString:@"正常"];
                    break;
                case 1:
                    [str appendString:@"故障"];
                    break;
                default:
                    [str appendString:@"未定义"];
                    break;
            }
            return str;
        }
		case 204:
        {
            NSMutableString *str = [NSMutableString stringWithString:@"故障信号（机油）："];
            //            String str = "故障信号（机油）：";
            switch (s0.intValue) {
                case 0:
                    [str appendString:@"正常"];
                    break;
                case 1:
                    [str appendString:@"故障"];
                    break;
                default:
                    [str appendString:@"未定义"];
                    break;
            }
            return str;
        }
		case 205:
        {
            NSMutableString *str = [NSMutableString stringWithString:@"故障信号（胎压）："];
            //            String str = "故障信号（胎压）：";
            switch (s0.intValue) {
                case 0:
                    [str appendString:@"正常"];
                    break;
                case 1:
                    [str appendString:@"故障"];
                    break;
                default:
                    [str appendString:@"未定义"];
                    break;
            }
            return str;
        }
		case 206:
        {
            NSMutableString *str = [NSMutableString stringWithString:@"故障信号（保养）："];
            //            String str = "故障信号（保养）：";
            switch (s0.intValue) {
                case 0:
                    [str appendString:@"正常"];
                    break;
                case 1:
                    [str appendString:@"故障"];
                    break;
                default:
                    [str appendString:@"未定义"];
                    break;
            }
            return str;
        }
		case 207:
        {
            NSMutableString *str = [NSMutableString stringWithString:@"安全气囊状态："];
            //            String str = "安全气囊状态：";
            switch (s0.intValue) {
                case 0:
                    [str appendString:@"正常"];
                    break;
                case 1:
                    [str appendString:@"故障"];
                    break;
                default:
                    [str appendString:@"未定义"];
                    break;
            }
            return str;
        }
		case 208:
        {
            NSMutableString *str = [NSMutableString stringWithString:@"ACC信号："];
            //            String str = "ACC信号：";
            switch (s0.intValue) {
                case 0:
                    [str appendString:@"无效"];
                    break;
                case 1:
                    [str appendString:@"有效"];
                    break;
                default:
                    [str appendString:@"未定义"];
                    break;
            }
            return str;
        }
		case 209:
        {
            NSMutableString *str = [NSMutableString stringWithString:@"钥匙状态："];
            //            String str = "钥匙状态：";
            switch (s0.intValue) {
                case 0:
                    [str appendString:@"无效"];
                    break;
                case 1:
                    [str appendString:@"有效"];
                    break;
                default:
                    [str appendString:@"未定义"];
                    break;
            }
            return str;
        }
		case 210:
        {
            NSMutableString *str = [NSMutableString stringWithString:@"遥控信号："];
            //            String str = "遥控信号：";
            switch (s0.intValue) {
                case 0:
                    [str appendString:@"未按"];
                    break;
                case 1:
                    [str appendString:@"开锁"];
                    break;
                case 2:
                    [str appendString:@"关锁"];
                    break;
                case 3:
                    [str appendString:@"尾箱锁"];
                    break;
                case 4:
                    [str appendString:@"长按开锁"];
                    break;
                case 5:
                    [str appendString:@"长按关锁"];
                    break;
                default:
                    [str appendString:@"未定义"];
                    break;
            }
            return str;
        }
		case 211:
        {
            NSMutableString *str = [NSMutableString stringWithString:@"雨刮状态："];
            //            String str = "雨刮状态：";
            switch (s0.intValue) {
                case 0:
                    [str appendString:@"关闭"];
                    break;
                case 1:
                    [str appendString:@"打开"];
                    break;
                default:
                    [str appendString:@"未定义"];
                    break;
            }
            return str;
        }
		case 212:
        {
            NSMutableString *str = [NSMutableString stringWithString:@"空调开关："];
            //            String str = "空调开关：";
            switch (s0.intValue) {
                case 0:
                    [str appendString:@"关闭"];
                    break;
                case 1:
                    [str appendString:@"打开"];
                    break;
                default:
                    [str appendString:@"未定义"];
                    break;
            }
            return str;
        }
        case 213:
            return [NSString stringWithFormat:@"左前轮轮速：%dkm/h", vper];
            //            return "左前轮轮速：" + ((Integer.parseInt(_ar[0])<<24)+(Integer.parseInt(_ar[1])<<16)+(Integer.parseInt(_ar[2])<<8)+(Integer.parseInt(_ar[3])))/100+ "km/h";
        case 214:
            return [NSString stringWithFormat:@"右前轮轮速：%dkm/h", vper];
            //            return "右前轮轮速：" + ((Integer.parseInt(_ar[0])<<24)+(Integer.parseInt(_ar[1])<<16)+(Integer.parseInt(_ar[2])<<8)+(Integer.parseInt(_ar[3])))/100+ "km/h";
        case 215:
            return [NSString stringWithFormat:@"左后轮轮速：%dkm/h", vper];
            //            return "左后轮轮速：" + ((Integer.parseInt(_ar[0])<<24)+(Integer.parseInt(_ar[1])<<16)+(Integer.parseInt(_ar[2])<<8)+(Integer.parseInt(_ar[3])))/100+ "km/h";
        case 216:
            return [NSString stringWithFormat:@"右后轮轮速：%dkm/h", vper];
            
            //            return "右后轮轮速：" + ((Integer.parseInt(_ar[0])<<24)+(Integer.parseInt(_ar[1])<<16)+(Integer.parseInt(_ar[2])<<8)+(Integer.parseInt(_ar[3])))/100+ "km/h";
        case 217:
            return [NSString stringWithFormat:@"左前轮气压：%dkPa", vper];
            //            return "左前轮气压：" + ((Integer.parseInt(_ar[0])<<24)+(Integer.parseInt(_ar[1])<<16)+(Integer.parseInt(_ar[2])<<8)+(Integer.parseInt(_ar[3])))/100+ "kPa";
        case 218:
            return [NSString stringWithFormat:@"右前轮气压：%dkPa", vper];
            //            return "右前轮气压：" + ((Integer.parseInt(_ar[0])<<24)+(Integer.parseInt(_ar[1])<<16)+(Integer.parseInt(_ar[2])<<8)+(Integer.parseInt(_ar[3])))/100+ "kPa";
        case 219:
            return [NSString stringWithFormat:@"左后轮气压：%dkPa", vper];
            //            return "左后轮气压：" + ((Integer.parseInt(_ar[0])<<24)+(Integer.parseInt(_ar[1])<<16)+(Integer.parseInt(_ar[2])<<8)+(Integer.parseInt(_ar[3])))/100+ "kPa";
        case 220:
            return [NSString stringWithFormat:@"右后轮气压：%dkPa", vper];
            //            return "右后轮气压：" + ((Integer.parseInt(_ar[0])<<24)+(Integer.parseInt(_ar[1])<<16)+(Integer.parseInt(_ar[2])<<8)+(Integer.parseInt(_ar[3])))/100+ "kPa";
        case 221:
            return [NSString stringWithFormat:@"左前轮胎温度：%d℃", vper];
            //            return "左前轮胎温度：" + ((Integer.parseInt(_ar[0])<<24)+(Integer.parseInt(_ar[1])<<16)+(Integer.parseInt(_ar[2])<<8)+(Integer.parseInt(_ar[3])))/100+ "℃";
        case 222:
            return [NSString stringWithFormat:@"右前轮胎温度：%d℃", vper];
            //            return "右前轮胎温度：" + ((Integer.parseInt(_ar[0])<<24)+(Integer.parseInt(_ar[1])<<16)+(Integer.parseInt(_ar[2])<<8)+(Integer.parseInt(_ar[3])))/100+ "℃";
        case 223:
            return [NSString stringWithFormat:@"左后轮胎温度：%d℃", vper];
            //            return "左后轮胎温度：" + ((Integer.parseInt(_ar[0])<<24)+(Integer.parseInt(_ar[1])<<16)+(Integer.parseInt(_ar[2])<<8)+(Integer.parseInt(_ar[3])))/100+ "℃";
        case 224:
            return [NSString stringWithFormat:@"右后轮胎温度：%d℃", vper];
            //            return "右后轮胎温度：" + ((Integer.parseInt(_ar[0])<<24)+(Integer.parseInt(_ar[1])<<16)+(Integer.parseInt(_ar[2])<<8)+(Integer.parseInt(_ar[3])))/100+ "℃";
        case 225:{
            NSMutableString *str = [NSMutableString stringWithString:@"驾驶员状态："];
            //        	String str="驾驶员状态:";
            
            CGFloat temp = ((int)((s1.doubleValue * 256 + s2.doubleValue)*10 + 0.5))/10;
            [str appendString:[NSString stringWithFormat:@"心率%dbpm，体温%0.1f℃", s0.intValue, temp]];
            
            // TODO
            //        	str+="心率"+Integer.parseInt(_ar[0])+"bpm,体温"+Constants.round(Double.parseDouble(_ar[1])*256+Double.parseDouble(_ar[2]),1,BigDecimal.ROUND_DOWN)+"℃";
            
            NSString *result = [OBDConstHelper intToBinaryString:s3.intValue];
            //        	String result = Integer.toBinaryString(Integer.parseInt(_ar[3]));
            //        	try {
            if(![NSString isEmpty:result] && ![result isEqualToString:@"0"])
            {
                switch([result substringAtRange:NSMakeRange(0, 1)].intValue){
                    case 0:
                        [str appendString:@"喂食否"];
                        break;
                    case 1:
                        [str appendString:@"喂食是"];
                        break;
                }
                switch([result substringAtRange:NSMakeRange(1, 1)].intValue){
                    case 0:
                        [str appendString:@"哭泣否"];
                        break;
                    case 1:
                        [str appendString:@"哭泣是"];
                        break;
                }
                switch([result substringAtRange:NSMakeRange(2, 1)].intValue){
                    case 0:
                        [str appendString:@"睡觉否"];
                        break;
                    case 1:
                        [str appendString:@"睡觉是"];
                        break;
                }
                switch([result substringAtRange:NSMakeRange(3, 1)].intValue){
                    case 0:
                        [str appendString:@"尿布湿"];
                        break;
                    case 1:
                        [str appendString:@"尿布干"];
                        break;
                }
                
                NSString *result56 = [result substringAtRange:NSMakeRange(4, 2)];
                
                if([@"01" isEqualToString:result56])
                {
                    [str appendString:@"情绪状态低落"];
                }
                else if([@"10" isEqualToString:result56])
                {
                    [str appendString:@"情绪状态一般"];
                }
                else if([@"11" isEqualToString:result56])
                {
                    [str appendString:@"情绪状态高亢"];
                }
            }
            //			} catch (Exception e) {
            //				// TODO Auto-generated catch block
            //				e.printStackTrace();
            //			}
	        return str;
        }
        default:
            return @"";
    }
}


//int IntegerToBinary(int number, char ret[], int ret_len)
//{
//    unsigned int index;
//    int i=0, N=sizeof(int)*CHAR_BIT;          //获取int类型的位数, CHAR_BIT为limit.h定义的宏，为CHAR的位数
//    if (ret_len < N)
//    {
//        return 0;
//    }
//    index = 1<<(N-1);                         //将1循环左移N-1次
//    for (i=0; i<N; ++i)
//    {
//        ret[i] = ((number&index)==0)?'0':'1'; //将需要求值的整型数与index按位相“与”，从最高位起判断是否为1
//        index >>= 1;                          //将index值循环右移
//    }
//    return 1;
//}

/**
 * 最新版
 * @param pid
 * @param array
 * @return
 * update time : 2014-07-30 by GA
 */
+ (NSString *)enPid:(int)pid toName:(NSArray *)array
{
    NSString *s0 = array[0];
    NSString *s1 = array[1];
    NSString *s2 = array[2];
    NSString *s3 = array[3];
    
    int v0 = s0.intValue << 24;
    int v1 = s1.intValue << 16;
    int v2 = s2.intValue << 8;
    int v3 = s3.intValue;
    
    int vall = (v0 + v1 + v2 +v3);
    int vper = vall/100;
    float vflo = ((int)(v0 + v1 + v2 + s3.doubleValue)*100.0 + 0.5)/10000.0;
    float vflo2 = ((int)(v0 + v1 + v2 + s3.doubleValue)*100.0 + 0.5)/10000.0;
    
    switch (pid)
    {
        case 1:
            return [NSString stringWithFormat:@"Number of DTCs：%d", s0.intValue];
        case 2:
            return [NSString stringWithFormat:@"Calculated engine load value：%d％", vper];
        case 3:
            return [NSString stringWithFormat:@"Engine coolant temperature：%d℃", vper];
        case 4:
            return [NSString stringWithFormat:@"Fuel pressure：%dkPa", vper];
        case 5:
            return [NSString stringWithFormat:@"Intake manifold absolute pressure：%dkPa", vper];
        case 12:
            // TODO:
            return [NSString stringWithFormat:@"Engine RPM：%0.2frpm", (s0.doubleValue * 256 + s1.doubleValue)/4];
            //            return "Engine RPM：" + Constants.round(((Double.parseDouble(_ar[0]) * 256 + Double.parseDouble(_ar[1])) / 4), 2, BigDecimal.ROUND_DOWN)+ "rpm";
        case 13:
            return [NSString stringWithFormat:@"Vehicle speed：%dkm/h", s0.intValue];
        case 8:
            // TODO:
            return [NSString stringWithFormat:@"Timing advance：%0.1f°", (v0 + v1 + v2 + s3.doubleValue)/100];
            //            return "Timing advance：" + Constants.round(((Integer.parseInt(_ar[0])<<24)+(Integer.parseInt(_ar[1])<<16)+(Integer.parseInt(_ar[2])<<8)+(Double.parseDouble(_ar[3])))/100,1,BigDecimal.ROUND_DOWN)+ "°";
        case 9:
            return [NSString stringWithFormat:@"Intake air temperature：%d℃", vper];
            //            return "Intake air temperature：" + ((Integer.parseInt(_ar[0])<<24)+(Integer.parseInt(_ar[1])<<16)+(Integer.parseInt(_ar[2])<<8)+(Integer.parseInt(_ar[3])))/100+ "℃";
        case 10:
            // TODO:
            return [NSString stringWithFormat:@"MAF air flow rate：%0.2fg/s", (v0 + v1 + v2 + s3.doubleValue)/100 ];
            //            return "MAF air flow rate：" + Constants.round(((Integer.parseInt(_ar[0])<<24)+(Integer.parseInt(_ar[1])<<16)+(Integer.parseInt(_ar[2])<<8)+(Double.parseDouble(_ar[3])))/100,2,BigDecimal.ROUND_DOWN)+ "g/s";
        case 11:
            return [NSString stringWithFormat:@"Throttle position：%d ％", vper];
            //            return "Throttle position：" + ((Integer.parseInt(_ar[0])<<24)+(Integer.parseInt(_ar[1])<<16)+(Integer.parseInt(_ar[2])<<8)+(Integer.parseInt(_ar[3])))/100+ "%";
        case 6:
        {
            NSMutableString *str = [NSMutableString stringWithString:@"Oxygen sensors present："];
            //            String str = "Oxygen sensors present：";
            switch (s0.intValue) {
                case 1:
                    [str appendString:@"O2S11"];
                    break;
                case 2:
                    [str appendString:@"O2S12"];
                    break;
                case 4:
                    [str appendString:@"O2S13"];
                    break;
                case 8:
                    [str appendString:@"O2S14"];
                    break;
                case 16:
                    [str appendString:@"O2S21"];
                    break;
                case 32:
                    [str appendString:@"O2S22"];
                    break;
                case 64:
                    [str appendString:@"O2S23"];
                    break;
                case 128:
                    [str appendString:@"O2S24"];
                    break;
                default:
                    [str appendString:@"Undefined"];
                    break;
            }
            return str;
        }
        case 7:
            // TODO:
            return [NSString stringWithFormat:@"Bank 1, Sensor 1: Oxygen sensor voltage：%0.1fV", vflo];
            //            return "Bank 1, Sensor 1: Oxygen sensor voltage：" + Constants.round(((Integer.parseInt(_ar[0])<<24)+(Integer.parseInt(_ar[1])<<16)+(Integer.parseInt(_ar[2])<<8)+(Double.parseDouble(_ar[3])))/100,3,BigDecimal.ROUND_DOWN)+ "V";
        case 14:
            // TODO:
            return [NSString stringWithFormat:@"Bank 1, Sensor 2: Oxygen sensor voltage：%0.1fV", vflo];
            //            return "Bank 1, Sensor 2: Oxygen sensor voltage：" + Constants.round(((Integer.parseInt(_ar[0])<<24)+(Integer.parseInt(_ar[1])<<16)+(Integer.parseInt(_ar[2])<<8)+(Double.parseDouble(_ar[3])))/100,3,BigDecimal.ROUND_DOWN)+ "V";
        case 15:
            // TODO:
            return [NSString stringWithFormat:@"Bank 1, Sensor 3: Oxygen sensor voltage：%0.1fV", vflo];
            //            return "Bank 1, Sensor 3: Oxygen sensor voltage：" + Constants.round(((Integer.parseInt(_ar[0])<<24)+(Integer.parseInt(_ar[1])<<16)+(Integer.parseInt(_ar[2])<<8)+(Double.parseDouble(_ar[3])))/100,3,BigDecimal.ROUND_DOWN)+ "V";
        case 16:
            // TODO:
            return [NSString stringWithFormat:@"Bank 1, Sensor 4: Oxygen sensor voltage：%0.1fV", vflo];
            //            return "Bank 1, Sensor 4: Oxygen sensor voltage：" + Constants.round(((Integer.parseInt(_ar[0])<<24)+(Integer.parseInt(_ar[1])<<16)+(Integer.parseInt(_ar[2])<<8)+(Double.parseDouble(_ar[3])))/100,3,BigDecimal.ROUND_DOWN)+ "V";
        case 17:
            // TODO:
            return [NSString stringWithFormat:@"Bank 2, Sensor 1: Oxygen sensor voltage：%0.1fV", vflo];
            //            return "Bank 2, Sensor 1: Oxygen sensor voltage：" + Constants.round(((Integer.parseInt(_ar[0])<<24)+(Integer.parseInt(_ar[1])<<16)+(Integer.parseInt(_ar[2])<<8)+(Double.parseDouble(_ar[3])))/100,3,BigDecimal.ROUND_DOWN)+ "V";
        case 18:
            // TODO:
            return [NSString stringWithFormat:@"Bank 2, Sensor 2: Oxygen sensor voltage：%0.1fV", vflo];
            //            return "Bank 2, Sensor 2: Oxygen sensor voltage：" + Constants.round(((Integer.parseInt(_ar[0])<<24)+(Integer.parseInt(_ar[1])<<16)+(Integer.parseInt(_ar[2])<<8)+(Double.parseDouble(_ar[3])))/100,3,BigDecimal.ROUND_DOWN)+ "V";
        case 19:
            // TODO:
            return [NSString stringWithFormat:@"Bank 2, Sensor 3: Oxygen sensor voltage：%0.1fV", vflo];
            //            return "Bank 2, Sensor 3: Oxygen sensor voltage：" + Constants.round(((Integer.parseInt(_ar[0])<<24)+(Integer.parseInt(_ar[1])<<16)+(Integer.parseInt(_ar[2])<<8)+(Double.parseDouble(_ar[3])))/100,3,BigDecimal.ROUND_DOWN)+ "V";
        case 20:
            // TODO:
            return [NSString stringWithFormat:@"Bank 2, Sensor 4: Oxygen sensor voltage：%0.1fV", vflo];
            //            return "Bank 2, Sensor 4: Oxygen sensor voltage：" + Constants.round(((Integer.parseInt(_ar[0])<<24)+(Integer.parseInt(_ar[1])<<16)+(Integer.parseInt(_ar[2])<<8)+(Double.parseDouble(_ar[3])))/100,3,BigDecimal.ROUND_DOWN)+ "V";
        case 21:
        {
            NSMutableString *str = [NSMutableString stringWithString:@"OBD standards："];
            switch (s0.intValue) {
                case 1:
                    [str appendString:@"OBDII"];
                    break;
                case 2:
                    [str appendString:@"OBD"];
                    break;
                case 3:
                    [str appendString:@"OBD&OBDII"];
                    break;
                case 4:
                    [str appendString:@"OBDI"];
                    break;
                case 5:
                    [str appendString:@"NO OBD"];
                    break;
                case 6:
                    [str appendString:@"EOBD"];
                    break;
                case 7:
                    [str appendString:@"EOBD&OBDII"];
                    break;
                case 8:
                    [str appendString:@"EOBD&OBD"];
                    break;
                case 9:
                    [str appendString:@"EOBD,OBD,OBDII"];
                    break;
                case 10:
                    [str appendString:@"JOBD"];
                    break;
                case 11:
                    [str appendString:@"JOBD&OBDII"];
                    break;
                case 12:
                    [str appendString:@"JOBD&EOBD"];
                    break;
                case 13:
                    [str appendString:@"JOBD,EOBD,OBDII"];
                    break;
                case 14:
                    [str appendString:@"EURO IVB1"];
                    break;
                case 15:
                    [str appendString:@"EURO V B2"];
                    break;
                case 16:
                    [str appendString:@"EURO C"];
                    break;
                case 17:
                    [str appendString:@"EMD"];
                    break;
                default:
                    [str appendString:@"Undefined"];
                    break;
            }
            return str;
        }
            
        case 22:
            return [NSString stringWithFormat:@"Run time since engine start：%dsec", vper];
            //            return "Run time since engine start：" + ((Integer.parseInt(_ar[0])<<24)+(Integer.parseInt(_ar[1])<<16)+(Integer.parseInt(_ar[2])<<8)+(Integer.parseInt(_ar[3])))/100+ "sec";
        case 23:
            return [NSString stringWithFormat:@"Distance traveled with malfunction indicator lamp on：%dkm", vper];
            //            return "Distance traveled with malfunction indicator lamp on：" + ((Integer.parseInt(_ar[0])<<24)+(Integer.parseInt(_ar[1])<<16)+(Integer.parseInt(_ar[2])<<8)+(Integer.parseInt(_ar[3])))/100+ "km";
        case 24:
            // TODO:
            return [NSString stringWithFormat:@"Fuel Rail Pressure：%0.1fkPa", vflo2];
            //            return "Fuel Rail Pressure：" + Constants.round(((Integer.parseInt(_ar[0])<<24)+(Integer.parseInt(_ar[1])<<16)+(Integer.parseInt(_ar[2])<<8)+(Double.parseDouble(_ar[3])))/100,2,BigDecimal.ROUND_DOWN)+ "kPa";
        case 25:
            // TODO:
            return [NSString stringWithFormat:@"Oxygen sensors voltage B1-S1：%0.1fV", vflo];
            //            return "Oxygen sensors voltage B1-S1：" + Constants.round(((Integer.parseInt(_ar[0])<<24)+(Integer.parseInt(_ar[1])<<16)+(Integer.parseInt(_ar[2])<<8)+(Double.parseDouble(_ar[3])))/100,3,BigDecimal.ROUND_DOWN)+ "V";
        case 26:
            // TODO:
            return [NSString stringWithFormat:@"Oxygen sensors voltage B1-S2：%0.1fV", vflo];
            //            return "Oxygen sensors voltage B1-S2：" + Constants.round(((Integer.parseInt(_ar[0])<<24)+(Integer.parseInt(_ar[1])<<16)+(Integer.parseInt(_ar[2])<<8))+(Double.parseDouble(_ar[3])/100),3,BigDecimal.ROUND_DOWN)+ "V";
        case 27:
            // TODO:
            return [NSString stringWithFormat:@"Oxygen sensors voltage B1-S3：%0.1fV", vflo];
            //            return "Oxygen sensors voltage B1-S3：" + Constants.round(((Integer.parseInt(_ar[0])<<24)+(Integer.parseInt(_ar[1])<<16)+(Integer.parseInt(_ar[2])<<8)+(Double.parseDouble(_ar[3])))/100,3,BigDecimal.ROUND_DOWN)+ "V";
        case 28:
            // TODO:
            return [NSString stringWithFormat:@"Oxygen sensors voltage B1-S4：%0.1fV", vflo];
            //            return "Oxygen sensors voltage B1-S4：" + Constants.round(((Integer.parseInt(_ar[0])<<24)+(Integer.parseInt(_ar[1])<<16)+(Integer.parseInt(_ar[2])<<8)+(Double.parseDouble(_ar[3])))/100,3,BigDecimal.ROUND_DOWN)+ "V";
        case 29:
            // TODO:
            return [NSString stringWithFormat:@"Oxygen sensors voltage B2-S1：%0.1fV", vflo];
            //            return "Oxygen sensors voltage B2-S1：" + Constants.round(((Integer.parseInt(_ar[0])<<24)+(Integer.parseInt(_ar[1])<<16)+(Integer.parseInt(_ar[2])<<8)+(Double.parseDouble(_ar[3])))/100,3,BigDecimal.ROUND_DOWN)+ "V";
        case 30:
            // TODO:
            return [NSString stringWithFormat:@"Oxygen sensors voltage B2-S2：%0.1fV", vflo];
            //            return "Oxygen sensors voltage B2-S2：" + Constants.round(((Integer.parseInt(_ar[0])<<24)+(Integer.parseInt(_ar[1])<<16)+(Integer.parseInt(_ar[2])<<8)+(Double.parseDouble(_ar[3])))/100,3,BigDecimal.ROUND_DOWN)+ "V";
        case 31:
            // TODO:
            return [NSString stringWithFormat:@"Oxygen sensors voltage B2-S3：%0.1fV", vflo];
            //            return "Oxygen sensors voltage B2-S3：" + Constants.round(((Integer.parseInt(_ar[0])<<24)+(Integer.parseInt(_ar[1])<<16)+(Integer.parseInt(_ar[2])<<8)+(Double.parseDouble(_ar[3])))/100,3,BigDecimal.ROUND_DOWN)+ "V";
        case 71:
            // TODO:
            return [NSString stringWithFormat:@"Oxygen sensors voltage B2-S4：%0.1fV", vflo];
            //            return "Oxygen sensors voltage B2-S4：" + Constants.round(((Integer.parseInt(_ar[0])<<24)+(Integer.parseInt(_ar[1])<<16)+(Integer.parseInt(_ar[2])<<8)+(Double.parseDouble(_ar[3])))/100,3,BigDecimal.ROUND_DOWN)+ "V";
        case 33:
            // TODO:
            return [NSString stringWithFormat:@"Commanded EGR：%d％", vper];
            //            return "Commanded EGR：" + ((Integer.parseInt(_ar[0])<<24)+(Integer.parseInt(_ar[1])<<16)+(Integer.parseInt(_ar[2])<<8)+(Integer.parseInt(_ar[3])))/100+ "%";
        case 34:
            // TODO:
            return [NSString stringWithFormat:@"EGR Error：%0.2f％", vflo2];
            //            return "EGR Error：" + Constants.round(((Integer.parseInt(_ar[0])<<24)+(Integer.parseInt(_ar[1])<<16)+(Integer.parseInt(_ar[2])<<8)+(Double.parseDouble(_ar[3])))/100,2,BigDecimal.ROUND_DOWN)+ "%";
        case 35:
            return [NSString stringWithFormat:@"Commanded evaporative purge：%d％", vper];
            //            return "Commanded evaporative purge：" + ((Integer.parseInt(_ar[0])<<24)+(Integer.parseInt(_ar[1])<<16)+(Integer.parseInt(_ar[2])<<8)+(Integer.parseInt(_ar[3])))/100+ "%";
        case 36:
            return [NSString stringWithFormat:@"Fuel level input：%d％", vper];
            //            return "Fuel level input：" + ((Integer.parseInt(_ar[0])<<24)+(Integer.parseInt(_ar[1])<<16)+(Integer.parseInt(_ar[2])<<8)+(Integer.parseInt(_ar[3])))/100+ "%";
        case 37:
            return [NSString stringWithFormat:@"number of warm-ups since DTC codes cleared：%d", vper];
            //            return "number of warm-ups since DTC codes cleared：" + ((Integer.parseInt(_ar[0])<<24)+(Integer.parseInt(_ar[1])<<16)+(Integer.parseInt(_ar[2])<<8)+(Integer.parseInt(_ar[3])))/100;
        case 38:
            return [NSString stringWithFormat:@"Distance traveled since DTC codes cleared：%dkm", vper];
            //            return "Distance traveled since DTC codes cleared：" + ((Integer.parseInt(_ar[0])<<24)+(Integer.parseInt(_ar[1])<<16)+(Integer.parseInt(_ar[2])<<8)+(Integer.parseInt(_ar[3])))/100+ "km";
        case 39:
            return [NSString stringWithFormat:@"Evaporative system vapor pressure：%dPa", vper];
            //            return "Evaporative system vapor pressure：" + ((Integer.parseInt(_ar[0])<<24)+(Integer.parseInt(_ar[1])<<16)+(Integer.parseInt(_ar[2])<<8)+(Integer.parseInt(_ar[3])))/100+ "Pa";
        case 40:
            return [NSString stringWithFormat:@"Barometric pressure：%dkPa", vper];
            //            return "Barometric pressure：" + ((Integer.parseInt(_ar[0])<<24)+(Integer.parseInt(_ar[1])<<16)+(Integer.parseInt(_ar[2])<<8)+(Integer.parseInt(_ar[3])))/100+ "kPa";
        case 41:
            // TODO:
            return [NSString stringWithFormat:@"Oxygen sensor current B1-S1：%0.2fmA", vflo2];
            //            return "Oxygen sensor current B1-S1：" + Constants.round(((Integer.parseInt(_ar[0])<<24)+(Integer.parseInt(_ar[1])<<16)+(Integer.parseInt(_ar[2])<<8)+(Double.parseDouble(_ar[3])))/100,2,BigDecimal.ROUND_DOWN)+ "mA";
        case 42:
            // TODO:
            return [NSString stringWithFormat:@"Oxygen sensor current B1-S2：%0.2fmA", vflo2];
            //            return "Oxygen sensor current B1-S2：" + Constants.round(((Integer.parseInt(_ar[0])<<24)+(Integer.parseInt(_ar[1])<<16)+(Integer.parseInt(_ar[2])<<8)+(Double.parseDouble(_ar[3])))/100,2,BigDecimal.ROUND_DOWN)+ "mA";
        case 43:
            // TODO:
            return [NSString stringWithFormat:@"Oxygen sensor current B1-S3：%0.2fmA", vflo2];
            //            return "Oxygen sensor current B1-S3：" + Constants.round(((Integer.parseInt(_ar[0])<<24)+(Integer.parseInt(_ar[1])<<16)+(Integer.parseInt(_ar[2])<<8)+(Double.parseDouble(_ar[3])))/100,2,BigDecimal.ROUND_DOWN)+ "mA";
        case 44:
            // TODO:
            return [NSString stringWithFormat:@"Oxygen sensor current B1-S4：%0.2fmA", vflo2];
            //            return "Oxygen sensor current(mA) B1-S4：" + Constants.round(((Integer.parseInt(_ar[0])<<24)+(Integer.parseInt(_ar[1])<<16)+(Integer.parseInt(_ar[2])<<8)+(Double.parseDouble(_ar[3])))/100,2,BigDecimal.ROUND_DOWN)+ "mA";
        case 45:
            // TODO:
            return [NSString stringWithFormat:@"Oxygen sensor current B2-S1：%0.2fmA", vflo2];
            //            return "Oxygen sensor current B2-S1：" + Constants.round(((Integer.parseInt(_ar[0])<<24)+(Integer.parseInt(_ar[1])<<16)+(Integer.parseInt(_ar[2])<<8)+(Double.parseDouble(_ar[3])))/100,2,BigDecimal.ROUND_DOWN)+ "mA";
        case 46:
            // TODO:
            return [NSString stringWithFormat:@"Oxygen sensor current B2-S2：%0.2fmA", vflo2];
            //            return "Oxygen sensor current B2-S2：" + Constants.round(((Integer.parseInt(_ar[0])<<24)+(Integer.parseInt(_ar[1])<<16)+(Integer.parseInt(_ar[2])<<8)+(Double.parseDouble(_ar[3])))/100,2,BigDecimal.ROUND_DOWN)+ "mA";
        case 47:
            // TODO:
            return [NSString stringWithFormat:@"Oxygen sensor current B2-S3：%0.2fmA", vflo2];
            //            return "Oxygen sensor current B2-S3：" + Constants.round(((Integer.parseInt(_ar[0])<<24)+(Integer.parseInt(_ar[1])<<16)+(Integer.parseInt(_ar[2])<<8)+(Double.parseDouble(_ar[3])))/100,2,BigDecimal.ROUND_DOWN)+ "mA";
        case 48:
            // TODO
            return [NSString stringWithFormat:@"Oxygen sensor current B2-S4：%0.2fmA", vflo2];
            //            return "Oxygen sensor current B2-S4：" + Constants.round(((Integer.parseInt(_ar[0])<<24)+(Integer.parseInt(_ar[1])<<16)+(Integer.parseInt(_ar[2])<<8)+(Double.parseDouble(_ar[3])))/100,2,BigDecimal.ROUND_DOWN)+ "mA";
        case 49:
            // TODO
            return [NSString stringWithFormat:@"Catalyst temperature B1-S1：%0.1f℃", vflo];
            //            return "Catalyst temperature B1-S1：" + Constants.round(((Integer.parseInt(_ar[0])<<24)+(Integer.parseInt(_ar[1])<<16)+(Integer.parseInt(_ar[2])<<8)+(Double.parseDouble(_ar[3])))/100,1,BigDecimal.ROUND_DOWN)+ "℃";
        case 50:
            // TODO
            return [NSString stringWithFormat:@"Catalyst temperature B2-S1：%0.1f℃", vflo];
            //            return "Catalyst temperature B2-S1：" + Constants.round(((Integer.parseInt(_ar[0])<<24)+(Integer.parseInt(_ar[1])<<16)+(Integer.parseInt(_ar[2])<<8)+(Double.parseDouble(_ar[3])))/100,1,BigDecimal.ROUND_DOWN)+ "℃";
        case 51:
            // TODO
            return [NSString stringWithFormat:@"Catalyst temperature B1-S2：%0.1f℃", vflo];
            //            return "Catalyst temperature B1-S2：" + Constants.round(((Integer.parseInt(_ar[0])<<24)+(Integer.parseInt(_ar[1])<<16)+(Integer.parseInt(_ar[2])<<8)+(Double.parseDouble(_ar[3])))/100,1,BigDecimal.ROUND_DOWN)+ "℃";
        case 52:
            // TODO
            return [NSString stringWithFormat:@"Catalyst temperature B2-S2：%0.1f℃", vflo];
            //            return "Catalyst temperature B2-S2：" + Constants.round(((Integer.parseInt(_ar[0])<<24)+(Integer.parseInt(_ar[1])<<16)+(Integer.parseInt(_ar[2])<<8)+(Double.parseDouble(_ar[3])))/100,1,BigDecimal.ROUND_DOWN)+ "℃";
        case 53:
            // TODO
            return [NSString stringWithFormat:@"Ambient air temperature：%d℃", vper];
            //            return "Ambient air temperature：" + ((Integer.parseInt(_ar[0])<<24)+(Integer.parseInt(_ar[1])<<16)+(Integer.parseInt(_ar[2])<<8)+(Integer.parseInt(_ar[3])))/100+ "℃";
        case 54:
            return [NSString stringWithFormat:@"Engine run time after MIL on：%dmin", vper];
            //            return "Engine run time after MIL on：" + ((Integer.parseInt(_ar[0])<<24)+(Integer.parseInt(_ar[1])<<16)+(Integer.parseInt(_ar[2])<<8)+(Integer.parseInt(_ar[3])))/100+ "min";
        case 55:
            return [NSString stringWithFormat:@"Engine run time after DTCs cleared：%dmin", vper];
            //            return "Engine run time after DTCs cleared：" + ((Integer.parseInt(_ar[0])<<24)+(Integer.parseInt(_ar[1])<<16)+(Integer.parseInt(_ar[2])<<8)+(Integer.parseInt(_ar[3])))/100+ "min";
        case 56:
            return [NSString stringWithFormat:@"Max voltage of oxygen sensors：%dV", vper];
            //            return "Max voltage of oxygen sensors：" + ((Integer.parseInt(_ar[0])<<24)+(Integer.parseInt(_ar[1])<<16)+(Integer.parseInt(_ar[2])<<8)+(Integer.parseInt(_ar[3])))/100+ "V";
        case 57:
            return [NSString stringWithFormat:@"Max current of oxygen sensors：%dmA", vper];
            //            return "Max current of oxygen sensors：" + ((Integer.parseInt(_ar[0])<<24)+(Integer.parseInt(_ar[1])<<16)+(Integer.parseInt(_ar[2])<<8)+(Integer.parseInt(_ar[3])))/100+ "mA";
        case 58:
            return [NSString stringWithFormat:@"Max value of air flow sensors：%dg/s", vper];
            //            return "Max value of air flow sensors：" + ((Integer.parseInt(_ar[0])<<24)+(Integer.parseInt(_ar[1])<<16)+(Integer.parseInt(_ar[2])<<8)+(Integer.parseInt(_ar[3])))/100 + "g/s";
        case 59:
        {
            NSMutableString *str = [NSMutableString stringWithString:@"Fuel type："];
            switch (s0.intValue) {
                case 1:
                    [str appendString:@"GAS"];
                    break;
                case 2:
                    [str appendString:@"METH"];
                    break;
                case 3:
                    [str appendString:@"ETH"];
                    break;
                case 4:
                    [str appendString:@"Diesel"];
                    break;
                case 5:
                    [str appendString:@"LPG"];
                    break;
                case 6:
                    [str appendString:@"CNG"];
                    break;
                case 7:
                    [str appendString:@"PROP"];
                    break;
                case 8:
                    [str appendString:@"ELEC"];
                    break;
                case 9:
                    [str appendString:@"BI_GAS"];
                    break;
                case 10:
                    [str appendString:@"BI_METH"];
                    break;
                case 11:
                    [str appendString:@"BI_ETH"];
                    break;
                case 12:
                    [str appendString:@"BI_METH"];
                    break;
                case 13:
                    [str appendString:@"BI_CNG"];
                    break;
                case 14:
                    [str appendString:@"BI_PROP"];
                    break;
                case 15:
                    [str appendString:@"BI_ELEC"];
                    break;
                default:
                    [str appendString:@"Undefined"];
                    break;
            }
            return str;
        }
        case 60:
            // TODO
            return [NSString stringWithFormat:@"Fuel Rail Pressure(absolute value)：%0.1fkPa", vflo];
            //            return "Fuel Rail Pressure(absolute value)：" + Constants.round(((Integer.parseInt(_ar[0])<<24)+(Integer.parseInt(_ar[1])<<16)+(Integer.parseInt(_ar[2])<<8)+(Double.parseDouble(_ar[3])))/100,1,BigDecimal.ROUND_DOWN)+ "kPa";
        case 61:
            // TODO
            return [NSString stringWithFormat:@"Accelerator pedal position：%0.1f％", vflo];
            //            return "Accelerator pedal position：" + Constants.round(((Integer.parseInt(_ar[0])<<24)+(Integer.parseInt(_ar[1])<<16)+(Integer.parseInt(_ar[2])<<8)+(Double.parseDouble(_ar[3])))/100,1,BigDecimal.ROUND_DOWN)+ "%";
        case 62:
            // TODO
            return [NSString stringWithFormat:@"Battery remaining life：%0.1f％", vflo];
            //            return "Battery remaining life：" + Constants.round(((Integer.parseInt(_ar[0])<<24)+(Integer.parseInt(_ar[1])<<16)+(Integer.parseInt(_ar[2])<<8)+(Double.parseDouble(_ar[3])))/100,1,BigDecimal.ROUND_DOWN)+ "%";
        case 63:
            // TODO
            return [NSString stringWithFormat:@"Engine oil temperature：%d℃", vper];
            //            return "Engine oil temperature：" + ((Integer.parseInt(_ar[0])<<24)+(Integer.parseInt(_ar[1])<<16)+(Integer.parseInt(_ar[2])<<8)+(Integer.parseInt(_ar[3])))/100+ "℃";
        case 72:
            // TODO
            return [NSString stringWithFormat:@"Fuel injection timing：%0.1f°", vflo];
            //            return "Fuel injection timing：" + Constants.round(((Integer.parseInt(_ar[0])<<24)+(Integer.parseInt(_ar[1])<<16)+(Integer.parseInt(_ar[2])<<8)+(Double.parseDouble(_ar[3])))/100,3,BigDecimal.ROUND_DOWN)+ "°";
        case 65:
            // TODO
            return [NSString stringWithFormat:@"Engine fuel rate：%0.2fL/h", vflo2];
            //            return "Engine fuel rate：" + Constants.round(((Integer.parseInt(_ar[0])<<24)+(Integer.parseInt(_ar[1])<<16)+(Integer.parseInt(_ar[2])<<8)+(Double.parseDouble(_ar[3])))/100,2,BigDecimal.ROUND_DOWN)+ "L/h";
        case 66:
        {
            NSMutableString *str = [NSMutableString stringWithFormat:@"Emission standards："];
            switch (s0.intValue) {
                case 14:
                    [str appendString:@"EURO IV B1"];
                    break;
                case 15:
                    [str appendString:@"RURO V B2"];
                    break;
                case 16:
                    [str appendString:@"EURO C"];
                    break;
                default:
                    [str appendString:@"Undefined"];
                    break;
            }
            return str;
        }
        case 67:
            return [NSString stringWithFormat:@"Fuel temperature：%d℃", vper];
            
            //            return "Fuel temperature：" + ((Integer.parseInt(_ar[0])<<24)+(Integer.parseInt(_ar[1])<<16)+(Integer.parseInt(_ar[2])<<8)+(Integer.parseInt(_ar[3])))/100+ "℃";
        case 68:
            return [NSString stringWithFormat:@"Engine run total time：%dsec", vper];
            //            return "Engine run total time：" + ((Integer.parseInt(_ar[0])<<24)+(Integer.parseInt(_ar[1])<<16)+(Integer.parseInt(_ar[2])<<8)+(Integer.parseInt(_ar[3])))/100+ "sec";
        case 69:
            return [NSString stringWithFormat:@"Engine standby total time：%dsec", vper];
            //            return "Engine standby total time：" + ((Integer.parseInt(_ar[0])<<24)+(Integer.parseInt(_ar[1])<<16)+(Integer.parseInt(_ar[2])<<8)+(Integer.parseInt(_ar[3])))/100+ "sec";
        case 70:
        {
            NSMutableString *str = [NSMutableString stringWithFormat:@"MIL status："];
            switch (s0.intValue) {
                case 0:
                    [str appendString:@"Off"];
                    break;
                case 1:
                    [str appendString:@"On"];
                    break;
                default:
                    [str appendString:@"Undefined"];
                    break;
            }
            return str;
        }
        case 135:
            return [NSString stringWithFormat:@"Engine runing time(Total)：%dsec", vper];
            //            return "Engine runing time(Total)：" + ((Integer.parseInt(_ar[0])<<24)+(Integer.parseInt(_ar[1])<<16)+(Integer.parseInt(_ar[2])<<8)+(Integer.parseInt(_ar[3])))/100+ "sec";
        case 136:
            return [NSString stringWithFormat:@"Engine runing time(Device On)：%dsec", vper];
            //            return "Engine runing time(Device On)：" + ((Integer.parseInt(_ar[0])<<24)+(Integer.parseInt(_ar[1])<<16)+(Integer.parseInt(_ar[2])<<8)+(Integer.parseInt(_ar[3])))/100+ "sec";
        case 137:
            return [NSString stringWithFormat:@"Engine runing time(Engine On)：%dsec", vper];
            //            return "Engine runing time(Engine On)：" + ((Integer.parseInt(_ar[0])<<24)+(Integer.parseInt(_ar[1])<<16)+(Integer.parseInt(_ar[2])<<8)+(Integer.parseInt(_ar[3])))/100+ "sec";
        case 138:
            return [NSString stringWithFormat:@"Fuel consumption(Total)：%dL", vper];
            //            return "Fuel consumption(Total)：" + ((Integer.parseInt(_ar[0])<<24)+(Integer.parseInt(_ar[1])<<16)+(Integer.parseInt(_ar[2])<<8)+(Integer.parseInt(_ar[3])))/100+ "L";
        case 139:
            return [NSString stringWithFormat:@"Fuel consumption(Device On)：%dL", vper];
            //            return "Fuel consumption(Device On)：" + ((Integer.parseInt(_ar[0])<<24)+(Integer.parseInt(_ar[1])<<16)+(Integer.parseInt(_ar[2])<<8)+(Integer.parseInt(_ar[3])))/100+ "L";
        case 140:
            return [NSString stringWithFormat:@"Fuel consumption(Engine On)：%dL", vper];
            //            return "Fuel consumption(Engine On)：" + ((Integer.parseInt(_ar[0])<<24)+(Integer.parseInt(_ar[1])<<16)+(Integer.parseInt(_ar[2])<<8)+(Integer.parseInt(_ar[3])))/100+ "L";
        case 141:
            return [NSString stringWithFormat:@"Average fuel sonsumption(Total)：%dL/100km", vper];
            //            return "Average fuel sonsumption(Total)：" + ((Integer.parseInt(_ar[0])<<24)+(Integer.parseInt(_ar[1])<<16)+(Integer.parseInt(_ar[2])<<8)+(Integer.parseInt(_ar[3])))/100+ "L/100km";
        case 142:
            return [NSString stringWithFormat:@"Average fuel sonsumption(Device On)：%dL/100km", vper];
            //            return "Average fuel sonsumption(Device On)：" + ((Integer.parseInt(_ar[0])<<24)+(Integer.parseInt(_ar[1])<<16)+(Integer.parseInt(_ar[2])<<8)+(Integer.parseInt(_ar[3])))/100+ "L/100km";
        case 143:
            return [NSString stringWithFormat:@"Average fuel sonsumption(Engine On)：%dL/100km", vper];
            //            return "Average fuel sonsumption(Engine On)：" + ((Integer.parseInt(_ar[0])<<24)+(Integer.parseInt(_ar[1])<<16)+(Integer.parseInt(_ar[2])<<8)+(Integer.parseInt(_ar[3])))/100+ "L/100km";
        case 144:
            return [NSString stringWithFormat:@"Fuel cost(Total)：%d￥", vper];
            //            return "Fuel cost(Total)：" + ((Integer.parseInt(_ar[0])<<24)+(Integer.parseInt(_ar[1])<<16)+(Integer.parseInt(_ar[2])<<8)+(Integer.parseInt(_ar[3])))/100+ "￥";
        case 145:
            return [NSString stringWithFormat:@"Fuel cost(Device On)：%d￥", vper];
            //            return "Fuel cost(Device On)：" + ((Integer.parseInt(_ar[0])<<24)+(Integer.parseInt(_ar[1])<<16)+(Integer.parseInt(_ar[2])<<8)+(Integer.parseInt(_ar[3])))/100+ "￥";
        case 146:
            return [NSString stringWithFormat:@"Fuel cost(Engine On)：%d￥", vper];
            //            return "Fuel cost(Engine On)：" + ((Integer.parseInt(_ar[0])<<24)+(Integer.parseInt(_ar[1])<<16)+(Integer.parseInt(_ar[2])<<8)+(Integer.parseInt(_ar[3])))/100+ "￥";
        case 147:
            return [NSString stringWithFormat:@"Distance traveled(Total)：%dkm", vper];
            //            return "Distance traveled(Total)：" + ((Integer.parseInt(_ar[0])<<24)+(Integer.parseInt(_ar[1])<<16)+(Integer.parseInt(_ar[2])<<8)+(Integer.parseInt(_ar[3])))/100+ "km";
        case 148:
            return [NSString stringWithFormat:@"Distance traveled(Device On)：%dkm", vper];
            //            return "Distance traveled(Device On)：" + ((Integer.parseInt(_ar[0])<<24)+(Integer.parseInt(_ar[1])<<16)+(Integer.parseInt(_ar[2])<<8)+(Integer.parseInt(_ar[3])))/100+ "km";
        case 149:
            return [NSString stringWithFormat:@"Distance traveled(Engine On)：%dkm", vper];
            //            return "Distance traveled(Engine On)：" + ((Integer.parseInt(_ar[0])<<24)+(Integer.parseInt(_ar[1])<<16)+(Integer.parseInt(_ar[2])<<8)+(Integer.parseInt(_ar[3])))/100+ "km";
        case 150:
            return [NSString stringWithFormat:@"Current fuel consumption(based on distance)：%dL/100km", vper];
            //            return "Current fuel consumption(based on distance)：" + ((Integer.parseInt(_ar[0])<<24)+(Integer.parseInt(_ar[1])<<16)+(Integer.parseInt(_ar[2])<<8)+(Integer.parseInt(_ar[3])))/100+ "L/100km";
        case 151:
            return [NSString stringWithFormat:@"Current fuel consumption(based on running time)：%dL/h", vper];
            //            return "Current fuel consumption(based on running time)：" + ((Integer.parseInt(_ar[0])<<24)+(Integer.parseInt(_ar[1])<<16)+(Integer.parseInt(_ar[2])<<8)+(Integer.parseInt(_ar[3])))/100+ "L/h";
		case 152:{
			NSMutableString *str = [NSMutableString stringWithFormat:@"Emission："];
            switch (s0.intValue)
            {
                case 0:
                    [str appendString:@"Pass"];
                    break;
                case 1:
                    [str appendString:@"No"];
                    break;
                default:
                    [str appendString:@"Undefined"];
                    break;
            }
            
            NSString *result = [OBDConstHelper intToBinaryString:s1.intValue];
            
            //            String result = Integer.toBinaryString(Integer.parseInt(_ar[1]));
            //			try {
            if (![NSString isEmpty:result] && ![result isEqualToString:@"0"])
            {
                switch ([result substringAtRange:NSMakeRange(0, 1)].intValue) {
                    case 0:
                        [str appendString:@"Catalyst : Pass"];
                        break;
                    case 1:
                        [str appendString:@"Catalyst : No"];
                        break;
                }
                switch ([result substringAtRange:NSMakeRange(1, 1)].intValue) {
                    case 0:
                        [str appendString:@"EGR : Pass"];
                        break;
                    case 1:
                        [str appendString:@"EGR : No"];
                        break;
                }
                switch ([result substringAtRange:NSMakeRange(2, 1)].intValue) {
                    case 0:
                        [str appendString:@"EVAP : Pass"];
                        break;
                    case 1:
                        [str appendString:@"EVAP : No"];
                        break;
                }
                switch ([result substringAtRange:NSMakeRange(3, 1)].intValue) {
                    case 0:
                        [str appendString:@"Pump monitoring : Pass"];
                        break;
                    case 1:
                        [str appendString:@"Pump monitoring : No"];
                        break;
                }
                switch ([result substringAtRange:NSMakeRange(4, 1)].intValue) {
                    case 0:
                        [str appendString:@"Heat oxygen sensor group : Pass"];
                        break;
                    case 1:
                        [str appendString:@"Heat oxygen sensor group : No"];
                        break;
                }
                switch ([result substringAtRange:NSMakeRange(5, 1)].intValue) {
                    case 0:
                        [str appendString:@"Heat catalyst : Pass"];
                        break;
                    case 1:
                        [str appendString:@"Heat catalyst : No"];
                        break;
                }
                switch ([result substringAtRange:NSMakeRange(6, 1)].intValue) {
                    case 0:
                        [str appendString:@"Engine misfire : No"];
                        break;
                    case 1:
                        [str appendString:@"Engine misfire : Yes"];
                        break;
                }
                switch ([result substringAtRange:NSMakeRange(7, 1)].intValue) {
                    case 0:
                        [str appendString:@"Heat oxygen sensor : Pass"];
                        break;
                    case 1:
                        [str appendString:@"Heat oxygen sensor : No"];
                        break;
                }
            }
            //			} catch (Exception e) {
            //				// TODO Auto-generated catch block
            //				e.printStackTrace();
            //			}
            return str;
		}
        case 153:
            // TODO
            return [NSString stringWithFormat:@"Battery remaining capacity：%0.2fV", vflo2];
            //            return "Battery remaining capacity：" + Constants.round(((Integer.parseInt(_ar[0])<<24)+(Integer.parseInt(_ar[1])<<16)+(Integer.parseInt(_ar[2])<<8)+(Double.parseDouble(_ar[3])))/100,2,BigDecimal.ROUND_DOWN)+ "V";
        case 170:
            // TODO
            return [NSString stringWithFormat:@"续航里程：%dkm", vper];
            //            return "续航里程：" + ((Integer.parseInt(_ar[0])<<24)+(Integer.parseInt(_ar[1])<<16)+(Integer.parseInt(_ar[2])<<8)+(Integer.parseInt(_ar[3])))/100+ "km";
        case 171:
            return [NSString stringWithFormat:@"Remaining Fuel：%dL", vper];
            //            return "Remaining Fuel：" + ((Integer.parseInt(_ar[0])<<24)+(Integer.parseInt(_ar[1])<<16)+(Integer.parseInt(_ar[2])<<8)+(Integer.parseInt(_ar[3])))/100+ "L";
        case 172:
            return [NSString stringWithFormat:@"续航里程：%d％", vper];
            //            return "续航里程：" + ((Integer.parseInt(_ar[0])<<24)+(Integer.parseInt(_ar[1])<<16)+(Integer.parseInt(_ar[2])<<8)+(Integer.parseInt(_ar[3])))/100+ "%";
		case 173:
        {
            NSMutableString *str = [NSMutableString stringWithString:@"Hand brake status："];
            switch (s0.intValue) {
                case 0:
                    [str appendString:@"Released"];
                    break;
                case 1:
                    [str appendString:@"Tighten"];
                    break;
                default:
                    [str appendString:@"Undefined"];
                    break;
            }
            return str;
        }
		case 174:
        {
            NSMutableString *str = [NSMutableString stringWithString:@"Foot brake："];
            //            String str = "Foot brake：";
            switch (s0.intValue) {
                case 0:
                    [str appendString:@"Released"];
                    break;
                case 1:
                    [str appendString:@"Pushed"];
                    break;
                default:
                    [str appendString:@"Undefined"];
                    break;
            }
            return str;
        }
		case 175:
        {
            NSMutableString *str = [NSMutableString stringWithString:@"Safe belt status："];
            //            String str = "Safe belt status：";
            switch (s0.intValue) {
                case 0:
                    [str appendString:@"Released"];
                    break;
                case 1:
                    [str appendString:@"Fastened"];
                    break;
                default:
                    [str appendString:@"Undefined"];
                    break;
            }
            return str;
        }
		case 176:
        {
            NSMutableString *str = [NSMutableString stringWithString:@"Safe belt status(co-pilot)："];
            //            String str = "Safe belt status(co-pilot)：";
            switch (s0.intValue) {
                case 0:
                    [str appendString:@"Released"];
                    break;
                case 1:
                    [str appendString:@"Fastened"];
                    break;
                default:
                    [str appendString:@"Undefined"];
                    break;
            }
            return str;
        }
       	case 177:
        {
            NSMutableString *str = [NSMutableString stringWithString:@"Gear status："];
            //            String str = "Gear status：";
            switch (s0.intValue) {
                case 1:
                    [str appendString:@"P"];
                    break;
                case 2:
                    [str appendString:@"R"];
                    break;
                case 3:
                    [str appendString:@"N"];
                    break;
                case 4:
                    [str appendString:@"D"];
                    break;
                default:
                    [str appendString:@"Undefined"];
                    break;
            }
            return str;
        }
		case 178:
        {
            NSMutableString *str = [NSMutableString stringWithString:@"Door(LF)："];
            //            String str = "Door(LF)：";
            switch (s0.intValue) {
                case 0:
                    [str appendString:@"Closed"];
                    break;
                case 1:
                    [str appendString:@"Opened"];
                    break;
                default:
                    [str appendString:@"Undefined"];
                    break;
            }
            return str;
        }
		case 179:
        {
            NSMutableString *str = [NSMutableString stringWithString:@"Door(RF)："];
            //            String str = "Door(RF)：";
            switch (s0.intValue) {
                case 0:
                    [str appendString:@"Closed"];
                    break;
                case 1:
                    [str appendString:@"Opened"];
                    break;
                default:
                    [str appendString:@"Undefined"];
                    break;
            }
            return str;
        }
		case 180:
        {
            NSMutableString *str = [NSMutableString stringWithString:@"Door(LR)："];
            //            String str = "Door(LR)：";
            switch (s0.intValue) {
                case 0:
                    [str appendString:@"Closed"];
                    break;
                case 1:
                    [str appendString:@"Opened"];
                    break;
                default:
                    [str appendString:@"Undefined"];
                    break;
            }
            return str;
        }
		case 181:
        {
            NSMutableString *str = [NSMutableString stringWithString:@"Door(RR)："];
            //            String str = "Door(RR)：";
            switch (s0.intValue) {
                case 0:
                    [str appendString:@"Closed"];
                    break;
                case 1:
                    [str appendString:@"Opened"];
                    break;
                default:
                    [str appendString:@"Undefined"];
                    break;
            }
            return str;
        }
		case 182:
        {
            NSMutableString *str = [NSMutableString stringWithString:@"Door（trunk）："];
            //            String str = "Door（trunk）：";
            switch (s0.intValue) {
                case 0:
                    [str appendString:@"Closed"];
                    break;
                case 1:
                    [str appendString:@"Opened"];
                    break;
                default:
                    [str appendString:@"Undefined"];
                    break;
            }
            return str;
        }
		case 183:
        {
            NSMutableString *str = [NSMutableString stringWithString:@"Door lock："];
            //            String str = "Door lock：";
            switch (s0.intValue) {
                case 0:
                    [str appendString:@"Unlocked"];
                    break;
                case 1:
                    [str appendString:@"Locked"];
                    break;
                default:
                    [str appendString:@"Undefined"];
                    break;
            }
            return str;
        }
		case 184:
        {
            NSMutableString *str = [NSMutableString stringWithString:@"Door lock(LF)："];
            //            String str = "Door lock(LF)：";
            switch (s0.intValue)
            {
                case 0:
                    [str appendString:@"Unlocked"];
                    break;
                case 1:
                    [str appendString:@"Locked"];
                    break;
                default:
                    [str appendString:@"Undefined"];
                    break;
            }
            return str;
        }
		case 185:
        {
            NSMutableString *str = [NSMutableString stringWithString:@"Door lock(RF)："];
            //            String str = "Door lock(RF)：";
            switch (s0.intValue) {
                case 0:
                    [str appendString:@"Unlocked"];
                    break;
                case 1:
                    [str appendString:@"Locked"];
                    break;
                default:
                    [str appendString:@"Undefined"];
                    break;
            }
            return str;
        }
		case 186:
        {
            NSMutableString *str = [NSMutableString stringWithString:@"Door lock(LR)："];
            //            String str = "Door lock(LR)：";
            
            switch (s0.intValue) {
                case 0:
                    [str appendString:@"Unlocked"];
                    break;
                case 1:
                    [str appendString:@"Locked"];
                    break;
                default:
                    [str appendString:@"Undefined"];
                    break;
            }
            return str;
        }
		case 187:
        {
            NSMutableString *str = [NSMutableString stringWithString:@"Door lock(RR)："];
            //            String str = "Door lock(RR)：";
            switch (s0.intValue) {
                case 0:
                    [str appendString:@"Unlocked"];
                    break;
                case 1:
                    [str appendString:@"Locked"];
                    break;
                default:
                    [str appendString:@"Undefined"];
                    break;
            }
            return str;
        }
		case 188:
        {
            NSMutableString *str = [NSMutableString stringWithString:@"Door lock(trunk)："];
            //            String str = "Door lock(trunk)：";
            switch (s0.intValue) {
                case 0:
                    [str appendString:@"Unlocked"];
                    break;
                case 1:
                    [str appendString:@"Locked"];
                    break;
                default:
                    [str appendString:@"Undefined"];
                    break;
            }
            return str;
        }
		case 189:
        {
            NSMutableString *str = [NSMutableString stringWithString:@"Car window(LF)："];
            //            String str = "Car window(LF)：";
            switch (s0.intValue)
            {
                case 0:
                    [str appendString:@"Closed"];
                    break;
                case 1:
                    [str appendString:@"Opened"];
                    break;
                default:
                    [str appendString:@"Undefined"];
                    break;
            }
            return str;
        }
		case 190:
        {
            NSMutableString *str = [NSMutableString stringWithString:@"Car window(RF)："];
            //            String str = "Car window(RF)：";
            switch (s0.intValue) {
                case 0:
                    [str appendString:@"Closed"];
                    break;
                case 1:
                    [str appendString:@"Opened"];
                    break;
                default:
                    [str appendString:@"Undefined"];
                    break;
            }
            return str;
        }
		case 191:
        {
            NSMutableString *str = [NSMutableString stringWithString:@"Car window(LR)："];
            //            String str = "Car window(LR)：";
            switch (s0.intValue) {
                case 0:
                    [str appendString:@"Closed"];
                    break;
                case 1:
                    [str appendString:@"Opened"];
                    break;
                default:
                    [str appendString:@"Undefined"];
                    break;
            }
            return str;
        }
		case 192:
        {
            NSMutableString *str = [NSMutableString stringWithString:@"Car window(RR)："];
            //            String str = "Car window(RR)：";
            switch (s0.intValue) {
                case 0:
                    [str appendString:@"Closed"];
                    break;
                case 1:
                    [str appendString:@"Opened"];
                    break;
                default:
                    [str appendString:@"Undefined"];
                    break;
            }
            return str;
        }
		case 193:
        {
            NSMutableString *str = [NSMutableString stringWithString:@"Car window(skylight)："];
            //            String str = "Car window(skylight)：";
            switch (s0.intValue) {
                case 0:
                    [str appendString:@"Closed"];
                    break;
                case 1:
                    [str appendString:@"Opened"];
                    break;
                default:
                    [str appendString:@"Undefined"];
                    break;
            }
            return str;
        }
		case 194:
        {
            NSMutableString *str = [NSMutableString stringWithString:@"Headlight status："];
            //            String str = "Headlight status：";
            switch (s0.intValue) {
                case 0:
                    [str appendString:@"Off"];
                    break;
                case 1:
                    [str appendString:@"On"];
                    break;
                default:
                    [str appendString:@"Undefined"];
                    break;
            }
            return str;
        }
		case 195:
        {
            NSMutableString *str = [NSMutableString stringWithString:@"Dipped headlight status："];
            //            String str = "Dipped headlight status：";
            switch (s0.intValue)
            {
                case 0:
                    [str appendString:@"Off"];
                    break;
                case 1:
                    [str appendString:@"On"];
                    break;
                default:
                    [str appendString:@"Undefined"];
                    break;
            }
            return str;
        }
		case 196:
        {
            NSMutableString *str = [NSMutableString stringWithString:@"Width light："];
            //            String str = "Width light：";
            switch (s0.intValue) {
                case 0:
                    [str appendString:@"Off"];
                    break;
                case 1:
                    [str appendString:@"On"];
                    break;
                default:
                    [str appendString:@"Undefined"];
                    break;
            }
            return str;
        }
		case 197:
        {
            NSMutableString *str = [NSMutableString stringWithString:@"Fog light："];
            //            String str = "Fog light：";
            switch (s0.intValue) {
                case 0:
                    [str appendString:@"Off"];
                    break;
                case 1:
                    [str appendString:@"On"];
                    break;
                default:
                    [str appendString:@"Undefined"];
                    break;
            }
            return str;
        }
		case 198:
        {
            NSMutableString *str = [NSMutableString stringWithString:@"Left direction light status："];
            //            String str = "Left direction light status：";
            switch (s0.intValue) {
                case 0:
                    [str appendString:@"Off"];
                    break;
                case 1:
                    [str appendString:@"On"];
                    break;
                default:
                    [str appendString:@"Undefined"];
                    break;
            }
            return str;
        }
		case 199:
        {
            NSMutableString *str = [NSMutableString stringWithString:@"Right direction light status："];
            //            String str = "Right direction light status：";
            switch (s0.intValue) {
                case 0:
                    [str appendString:@"Off"];
                    break;
                case 1:
                    [str appendString:@"On"];
                    break;
                default:
                    [str appendString:@"Undefined"];
                    break;
            }
            return str;
        }
		case 200:
        {
            NSMutableString *str = [NSMutableString stringWithString:@"Flasher light status："];
            //            String str = "Flasher light status：";
            switch (s0.intValue)
            {
                case 0:
                    [str appendString:@"Off"];
                    break;
                case 1:
                    [str appendString:@"On"];
                    break;
                default:
                    [str appendString:@"Undefined"];
                    break;
            }
            return str;
        }
		case 201:
        {
            NSMutableString *str = [NSMutableString stringWithString:@"Fault signal（ECM）："];
            //            String str = "Fault signal（ECM）：";
            switch (s0.intValue) {
                case 0:
                    [str appendString:@"Normal"];
                    break;
                case 1:
                    [str appendString:@"Error"];
                    break;
                default:
                    [str appendString:@"Undefined"];
                    break;
            }
            return str;
        }
		case 202:
        {
            NSMutableString *str = [NSMutableString stringWithString:@"Fault signal（ABS）："];
            //            String str = "Fault signal（ABS）：";
            switch (s0.intValue) {
                case 0:
                    [str appendString:@"Normal"];
                    break;
                case 1:
                    [str appendString:@"Error"];
                    break;
                default:
                    [str appendString:@"Undefined"];
                    break;
            }
            return str;
        }
		case 203:
        {
            NSMutableString *str = [NSMutableString stringWithString:@"Fault signal（SRS）："];
            //            String str = "Fault signal（SRS）：";
            switch (s0.intValue) {
                case 0:
                    [str appendString:@"Normal"];
                    break;
                case 1:
                    [str appendString:@"Error"];
                    break;
                default:
                    [str appendString:@"Undefined"];
                    break;
            }
            return str;
        }
		case 204:
        {
            NSMutableString *str = [NSMutableString stringWithString:@"Fault signal（engine oil）："];
            //            String str = "Fault signal（engine oil）：";
            switch (s0.intValue) {
                case 0:
                    [str appendString:@"Normal"];
                    break;
                case 1:
                    [str appendString:@"Error"];
                    break;
                default:
                    [str appendString:@"Undefined"];
                    break;
            }
            return str;
        }
		case 205:
        {
            NSMutableString *str = [NSMutableString stringWithString:@"Fault signal（tire pressure）："];
            //            String str = "Fault signal（tire pressure）：";
            switch (s0.intValue) {
                case 0:
                    [str appendString:@"Normal"];
                    break;
                case 1:
                    [str appendString:@"Error"];
                    break;
                default:
                    [str appendString:@"Undefined"];
                    break;
            }
            return str;
        }
		case 206:
        {
            NSMutableString *str = [NSMutableString stringWithString:@"Fault signal（maintenance）："];
            //            String str = "Fault signal（maintenance）：";
            switch (s0.intValue) {
                case 0:
                    [str appendString:@"Normal"];
                    break;
                case 1:
                    [str appendString:@"Error"];
                    break;
                default:
                    [str appendString:@"Undefined"];
                    break;
            }
            return str;
        }
		case 207:
        {
            NSMutableString *str = [NSMutableString stringWithString:@"Airbag status："];
            //            String str = "Airbag status：";
            switch (s0.intValue) {
                case 0:
                    [str appendString:@"Normal"];
                    break;
                case 1:
                    [str appendString:@"Error"];
                    break;
                default:
                    [str appendString:@"Undefined"];
                    break;
            }
            return str;
        }
		case 208:
        {
            NSMutableString *str = [NSMutableString stringWithString:@"ACC signal："];
            //            String str = "ACC signal：";
            switch (s0.intValue) {
                case 0:
                    [str appendString:@"Invalid"];
                    break;
                case 1:
                    [str appendString:@"Valid"];
                    break;
                default:
                    [str appendString:@"Undefined"];
                    break;
            }
            return str;
        }
		case 209:
        {
            NSMutableString *str = [NSMutableString stringWithString:@"Key status："];
            //            String str = "Key status：";
            switch (s0.intValue) {
                case 0:
                    [str appendString:@"Invalid"];
                    break;
                case 1:
                    [str appendString:@"Valid"];
                    break;
                default:
                    [str appendString:@"Undefined"];
                    break;
            }
            return str;
        }
		case 210:
        {
            NSMutableString *str = [NSMutableString stringWithString:@"Remote signal："];
            //            String str = "Remote signal：";
            switch (s0.intValue) {
                case 0:
                    [str appendString:@"No operation"];
                    break;
                case 1:
                    [str appendString:@"Unlock"];
                    break;
                case 2:
                    [str appendString:@"Lock"];
                    break;
                case 3:
                    [str appendString:@"Trunk lock"];
                    break;
                case 4:
                    [str appendString:@"Long press unlock"];
                    break;
                case 5:
                    [str appendString:@"Long press lock"];
                    break;
                default:
                    [str appendString:@"Undefined"];
                    break;
            }
            return str;
        }
		case 211:
        {
            NSMutableString *str = [NSMutableString stringWithString:@"Windscreen wiper status："];
            //            String str = "Windscreen wiper status：";
            switch (s0.intValue) {
                case 0:
                    [str appendString:@"Closed"];
                    break;
                case 1:
                    [str appendString:@"Opened"];
                    break;
                default:
                    [str appendString:@"Undefined"];
                    break;
            }
            return str;
        }
		case 212:
        {
            NSMutableString *str = [NSMutableString stringWithString:@"Air conditioner switch："];
            //            String str = "Air conditioner switch：";
            switch (s0.intValue) {
                case 0:
                    [str appendString:@"Off"];
                    break;
                case 1:
                    [str appendString:@"On"];
                    break;
                default:
                    [str appendString:@"Undefined"];
                    break;
            }
            return str;
        }
        case 213:
            return [NSString stringWithFormat:@"Tire speed(LF)：%dkm/h", vper];
            //            return "Tire speed(LF)：" + ((Integer.parseInt(_ar[0])<<24)+(Integer.parseInt(_ar[1])<<16)+(Integer.parseInt(_ar[2])<<8)+(Integer.parseInt(_ar[3])))/100+ "km/h";
        case 214:
            return [NSString stringWithFormat:@"Tire speed(RF)：%dkm/h", vper];
            //            return "Tire speed(RF)：" + ((Integer.parseInt(_ar[0])<<24)+(Integer.parseInt(_ar[1])<<16)+(Integer.parseInt(_ar[2])<<8)+(Integer.parseInt(_ar[3])))/100+ "km/h";
        case 215:
            return [NSString stringWithFormat:@"Tire speed(LR)：%dkm/h", vper];
            //            return "Tire speed(LR)：" + ((Integer.parseInt(_ar[0])<<24)+(Integer.parseInt(_ar[1])<<16)+(Integer.parseInt(_ar[2])<<8)+(Integer.parseInt(_ar[3])))/100+ "km/h";
        case 216:
            return [NSString stringWithFormat:@"Tire speed(RR)：%dkm/h", vper];
            //            return "Tire speed(RR)：" + ((Integer.parseInt(_ar[0])<<24)+(Integer.parseInt(_ar[1])<<16)+(Integer.parseInt(_ar[2])<<8)+(Integer.parseInt(_ar[3])))/100+ "km/h";
        case 217:
            return [NSString stringWithFormat:@"Tire pressure(LF)：%dkPa", vper];
            //            return "Tire pressure(LF)：" + ((Integer.parseInt(_ar[0])<<24)+(Integer.parseInt(_ar[1])<<16)+(Integer.parseInt(_ar[2])<<8)+(Integer.parseInt(_ar[3])))/100+ "kPa";
        case 218:
            return [NSString stringWithFormat:@"Tire pressure(RF)：%dkPa", vper];
            //            return "Tire pressure(RF)：" + ((Integer.parseInt(_ar[0])<<24)+(Integer.parseInt(_ar[1])<<16)+(Integer.parseInt(_ar[2])<<8)+(Integer.parseInt(_ar[3])))/100+ "kPa";
        case 219:
            return [NSString stringWithFormat:@"Tire pressure(LR)：%dkPa", vper];
            //            return "Tire pressure(LR)：" + ((Integer.parseInt(_ar[0])<<24)+(Integer.parseInt(_ar[1])<<16)+(Integer.parseInt(_ar[2])<<8)+(Integer.parseInt(_ar[3])))/100+ "kPa";
        case 220:
            return [NSString stringWithFormat:@"Tire pressure(RR)：%dkPa", vper];
            //            return "Tire pressure(RR)：" + ((Integer.parseInt(_ar[0])<<24)+(Integer.parseInt(_ar[1])<<16)+(Integer.parseInt(_ar[2])<<8)+(Integer.parseInt(_ar[3])))/100+ "kPa";
        case 221:
            return [NSString stringWithFormat:@"Tire temperature(LF)：%d℃", vper];
            //            return "Tire temperature(LF)：" + ((Integer.parseInt(_ar[0])<<24)+(Integer.parseInt(_ar[1])<<16)+(Integer.parseInt(_ar[2])<<8)+(Integer.parseInt(_ar[3])))/100+ "℃";
        case 222:
            return [NSString stringWithFormat:@"Tire temperature(RF)：%d℃", vper];
            //            return "Tire temperature(RF)：" + ((Integer.parseInt(_ar[0])<<24)+(Integer.parseInt(_ar[1])<<16)+(Integer.parseInt(_ar[2])<<8)+(Integer.parseInt(_ar[3])))/100+ "℃";
        case 223:
            return [NSString stringWithFormat:@"Tire temperature(LR)：%d℃", vper];
            //            return "Tire temperature(LR)：" + ((Integer.parseInt(_ar[0])<<24)+(Integer.parseInt(_ar[1])<<16)+(Integer.parseInt(_ar[2])<<8)+(Integer.parseInt(_ar[3])))/100+ "℃";
        case 224:
            return [NSString stringWithFormat:@"Tire temperature(RR)：%d℃", vper];
            //            return "Tire temperature(RR)：" + ((Integer.parseInt(_ar[0])<<24)+(Integer.parseInt(_ar[1])<<16)+(Integer.parseInt(_ar[2])<<8)+(Integer.parseInt(_ar[3])))/100+ "℃";
        case 225:{
            NSMutableString *str = [NSMutableString stringWithString:@"Driver status："];
            //        	String str="Driver status:";
            
            CGFloat temp = ((int)((s1.doubleValue * 256 + s2.doubleValue)*10 + 0.5))/10;
            [str appendString:[NSString stringWithFormat:@"Heartbeat%dbpm，Temperature%0.1f℃", s0.intValue, temp]];
            
            // TODO
            //        	str+="Heartbeat"+Integer.parseInt(_ar[0])+"bpm,Temperature"+Constants.round(Double.parseDouble(_ar[1])*256+Double.parseDouble(_ar[2]),1,BigDecimal.ROUND_DOWN)+"℃";
            
            NSString *result = [OBDConstHelper intToBinaryString:s3.intValue];
            //        	String result = Integer.toBinaryString(Integer.parseInt(_ar[3]));
            //        	try {
            if(![NSString isEmpty:result] && ![result isEqualToString:@"0"])
            {
                switch([result substringAtRange:NSMakeRange(0, 1)].intValue){
                    case 0:
                        [str appendString:@"Feed : NO"];
                        break;
                    case 1:
                        [str appendString:@"Feed : YES"];
                        break;
                }
                switch([result substringAtRange:NSMakeRange(1, 1)].intValue){
                    case 0:
                        [str appendString:@"Crying : NO"];
                        break;
                    case 1:
                        [str appendString:@"Crying : YES"];
                        break;
                }
                switch([result substringAtRange:NSMakeRange(2, 1)].intValue){
                    case 0:
                        [str appendString:@"Sleep : NO"];
                        break;
                    case 1:
                        [str appendString:@"Sleep : YES"];
                        break;
                }
                switch([result substringAtRange:NSMakeRange(3, 1)].intValue){
                    case 0:
                        [str appendString:@"Diaper : WET"];
                        break;
                    case 1:
                        [str appendString:@"Diaper : DRY"];
                        break;
                }
                
                NSString *result56 = [result substringAtRange:NSMakeRange(4, 2)];
                
                if([@"01" isEqualToString:result56])
                {
                    [str appendString:@"Mood : Negative"];
                }
                else if([@"10" isEqualToString:result56])
                {
                    [str appendString:@"Mood : Neutral"];
                }
                else if([@"11" isEqualToString:result56])
                {
                    [str appendString:@"Mood : Positive"];
                }
            }
            //			} catch (Exception e) {
            //				// TODO Auto-generated catch block
            //				e.printStackTrace();
            //			}
	        return str;
        }
        default:
            return @"";
    }
}


@end

#endif
