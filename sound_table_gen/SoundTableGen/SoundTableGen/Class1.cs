using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace SoundTableGen
{
    class Class1
    {
        static string[] stringSeparators = new string[] { "\r\n" };

        static void Main(string[] args)
        {
            ushort[] table1 = new ushort[0x300];
            ushort[] table2 = new ushort[0x300];

            String mappingText = File.ReadAllText(args[0]);
            String[] split = mappingText.Split(stringSeparators, StringSplitOptions.None);
            foreach (String splitString in split)
            {
                String[] splitski = splitString.Split(' ');
                int from = Convert.ToInt32(splitski[0], 16);
                if (splitski.Length > 2)
                {
                    try
                    {
                        int to = Convert.ToInt32(splitski[2], 16);
                        Console.WriteLine(from + " " + to);
                        table2[from] = (ushort)to;
                    }
                    catch (System.FormatException exc)
                    {
                    }
                }
                if (splitski.Length > 1)
                {
                    try { 
                        int to = Convert.ToInt32(splitski[1], 16);
                        Console.WriteLine(from + " " + to);
                        table1[from] = (ushort)to;
                    }
                    catch (System.FormatException exc)
                    {
                    }
                }
            }

            for (int x = 0; x < 0x24; x ++)
            {
                table1[x] = (ushort)x;
            }


            byte[] byteTable1 = new byte[0x600];
            byte[] byteTable2 = new byte[0x600];
            for (int x = 0; x < 0x300; x ++)
            {
                byteTable1[x * 2 + 1] = (byte)(table1[x] & 0xFF);
                byteTable1[x * 2] = (byte)((table1[x] & 0xFF00) >> 8);
                byteTable2[x * 2 + 1] = (byte)(table2[x] & 0xFF);
                byteTable2[x * 2] = (byte)((table2[x] & 0xFF00) >> 8);
            }

            File.WriteAllBytes("sound_mappings.bin", byteTable1);
            File.WriteAllBytes("secondary_sound_mappings.bin", byteTable2);
        }
    }
}
