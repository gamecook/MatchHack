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

    import flash.display.Bitmap;

    public class CharacterFactory
    {

        [Embed(source="../../../../../build/assets/characters/player_01.png")]
        private static var Player1:Class;

        [Embed(source="../../../../../build/assets/characters/monster_01.png")]
        private static var Monster1:Class;

        [Embed(source="../../../../../build/assets/characters/monster_02.png")]
        private static var Monster2:Class;

        [Embed(source="../../../../../build/assets/characters/monster_03.png")]
        private static var Monster3:Class;

        [Embed(source="../../../../../build/assets/characters/monster_04.png")]
        private static var Monster4:Class;

        [Embed(source="../../../../../build/assets/characters/monster_05.png")]
        private static var Monster5:Class;

        [Embed(source="../../../../../build/assets/characters/monster_06.png")]
        private static var Monster6:Class;

        [Embed(source="../../../../../build/assets/characters/monster_07.png")]
        private static var Monster7:Class;

        [Embed(source="../../../../../build/assets/characters/monster_08.png")]
        private static var Monster8:Class;

        [Embed(source="../../../../../build/assets/characters/monster_09.png")]
        private static var Monster9:Class;

        private static var sprites:Array = [Monster1,
            Monster2,
            Monster3,
            Monster4,
            Monster5,
            Monster6,
            Monster7,
            Monster8,
            Monster9];

        public static function createMonster(number:int = 0):Bitmap
        {
            //TODO need a way to pick a specific monster
            var classInstance:Class = ArrayUtil.shuffleArray(sprites).slice(0, 1)[0] as Class;
            return new classInstance() as Bitmap;
        }

        public static function createPlayerBitmap():Bitmap
        {
            return new Player1() as Bitmap;
        }
    }
}
