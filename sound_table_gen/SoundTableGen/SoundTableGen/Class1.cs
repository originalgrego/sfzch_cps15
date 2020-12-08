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
            ushort[] table = new ushort[0x300];
            String mappingText = File.ReadAllText(args[0]);
            String[] split = mappingText.Split(stringSeparators, StringSplitOptions.None);
            foreach (String splitString in split)
            {
                String[] splitski = splitString.Split(' ');
                if (splitski.Length > 1)
                {
                    int from = Convert.ToInt32(splitski[0], 16);
                    try { 
                        int to = Convert.ToInt32(splitski[1], 16);
                        Console.WriteLine(from + " " + to);
                        table[from] = (ushort)to;
                    }
                    catch (System.FormatException exc)
                    {
                    }
                }
            }
            for (int x = 0; x < 0x21; x ++)
            {
                table[x] = (ushort)x;
            }

            byte[] byteTable = new byte[0x600];
            for (int x = 0; x < 0x300; x ++)
            {
                byteTable[x * 2 + 1] = (byte)(table[x] & 0xFF);
                byteTable[x * 2] = (byte)((table[x] & 0xFF00) >> 8);
            }

            File.WriteAllBytes("Output.bin", byteTable);

        }

    }
}
