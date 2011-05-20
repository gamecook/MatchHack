/*
 * Copyright (c) 2011 Jesse Freeman
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */

package com.gamecook.matchhack.factories
{
    import com.gamecook.matchhack.utils.ArrayUtil;

    public class SpriteFactory
    {

        
        private static var sprites:Array = [
                                            'T',
                                            '$',
                                            'P',
                                            'W1',
                                            'W2',
                                            'W3',
                                            'W4',
                                            'W5',
                                            'W6',
                                            'W7',
                                            'W8',
                                            'W9',
                                            'W10',
                                            'W11',
                                            'W12',
                                            'W13',
                                            'W14',
                                            'W15',
                                            'W16',
                                            'W17',
                                            'W18',
                                            'W19',
                                            'W20',
                                            'W21',
                                            'W22',
                                            'W23',
                                            'W24',
                                            'W25',
                                            'W26',
                                            'W27',
                                            'S1',
                                            'S2',
                                            'S3',
                                            'S4',
                                            'S5',
                                            'S6',
                                            'S7',
                                            'H1',
                                            'H2',
                                            'H3',
                                            'H4',
                                            'H5',
                                            'H6',
                                            'H7',
                                            'H8',
                                            'H9',
                                            'H10',
                                            'A1',
                                            'A2',
                                            'A3',
                                            'A4',
                                            'A5',
                                            'A6',
                                            'A7',
                                            'A8',
                                            'A9',
                                            'A10',
                                            'B1',
                                            'B2',
                                            'B3'
                                            ];

        public static function createSprites(number:int):Array
        {
            //TODO need to add in logic to make sure there is a potion or gold in at least one round
            return ArrayUtil.shuffleArray(sprites).slice(0, number);
        }

    }
}
