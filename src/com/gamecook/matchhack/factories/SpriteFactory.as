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

        
        private static var sprites:Array = ['sprite4',
                                            'sprite5',
                                            'sprite6',
                                            'sprite60',
                                            'sprite61',
                                            'sprite62',
                                            'sprite63',
                                            'sprite64',
                                            'sprite65',
                                            'sprite66',
                                            'sprite67',
                                            'sprite68',
                                            'sprite69',
                                            'sprite70',
                                            'sprite71',
                                            'sprite72',
                                            'sprite73',
                                            'sprite74',
                                            'sprite75',
                                            'sprite76',
                                            'sprite77',
                                            'sprite78',
                                            'sprite79',
                                            'sprite80',
                                            'sprite81',
                                            'sprite82',
                                            'sprite83',
                                            'sprite84',
                                            'sprite85',
                                            'sprite86',
                                            'sprite87',
                                            'sprite89',
                                            'sprite90',
                                            'sprite91',
                                            'sprite92',
                                            'sprite93',
                                            'sprite94',
                                            ];

        public static function createSprites(number:int):Array
        {
            //TODO need to add in logic to make sure there is a potion or gold in at least one round
            return ArrayUtil.shuffleArray(sprites).slice(0, number);
        }

    }
}
