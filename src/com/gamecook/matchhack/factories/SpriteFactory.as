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

        [Embed(source="../../../../../build/assets/sprites/sprite_01.png")]
        private static var Sprite1:Class;

        [Embed(source="../../../../../build/assets/sprites/sprite_02.png")]
        private static var Sprite2:Class;

        [Embed(source="../../../../../build/assets/sprites/sprite_03.png")]
        private static var Sprite3:Class;

        [Embed(source="../../../../../build/assets/sprites/sprite_04.png")]
        private static var Sprite4:Class;

        [Embed(source="../../../../../build/assets/sprites/sprite_05.png")]
        private static var Sprite5:Class;

        [Embed(source="../../../../../build/assets/sprites/sprite_06.png")]
        private static var Sprite6:Class;

        [Embed(source="../../../../../build/assets/sprites/sprite_07.png")]
        private static var Sprite7:Class;

        [Embed(source="../../../../../build/assets/sprites/sprite_08.png")]
        private static var Sprite8:Class;

        [Embed(source="../../../../../build/assets/sprites/sprite_09.png")]
        private static var Sprite9:Class;

        [Embed(source="../../../../../build/assets/sprites/sprite_10.png")]
        private static var Sprite10:Class;

        [Embed(source="../../../../../build/assets/sprites/sprite_11.png")]
        private static var Sprite11:Class;

        [Embed(source="../../../../../build/assets/sprites/sprite_12.png")]
        private static var Sprite12:Class;

        [Embed(source="../../../../../build/assets/sprites/sprite_13.png")]
        private static var Sprite13:Class;

        [Embed(source="../../../../../build/assets/sprites/sprite_14.png")]
        private static var Sprite14:Class;

        [Embed(source="../../../../../build/assets/sprites/sprite_15.png")]
        private static var Sprite15:Class;

        [Embed(source="../../../../../build/assets/sprites/sprite_16.png")]
        private static var Sprite16:Class;

        [Embed(source="../../../../../build/assets/sprites/sprite_17.png")]
        private static var Sprite17:Class;

        [Embed(source="../../../../../build/assets/sprites/sprite_18.png")]
        private static var Sprite18:Class;

        [Embed(source="../../../../../build/assets/sprites/sprite_19.png")]
        private static var Sprite19:Class;

        [Embed(source="../../../../../build/assets/sprites/sprite_20.png")]
        private static var Sprite20:Class;

        [Embed(source="../../../../../build/assets/sprites/sprite_21.png")]
        private static var Sprite21:Class;

        [Embed(source="../../../../../build/assets/sprites/sprite_22.png")]
        private static var Sprite22:Class;

        [Embed(source="../../../../../build/assets/sprites/sprite_23.png")]
        private static var Sprite23:Class;

        [Embed(source="../../../../../build/assets/sprites/sprite_24.png")]
        private static var Sprite24:Class;

        [Embed(source="../../../../../build/assets/sprites/sprite_25.png")]
        private static var Sprite25:Class;

        [Embed(source="../../../../../build/assets/sprites/sprite_26.png")]
        private static var Sprite26:Class;

        [Embed(source="../../../../../build/assets/sprites/sprite_27.png")]
        private static var Sprite27:Class;

        [Embed(source="../../../../../build/assets/sprites/sprite_28.png")]
        private static var Sprite28:Class;

        [Embed(source="../../../../../build/assets/sprites/sprite_29.png")]
        private static var Sprite29:Class;

        [Embed(source="../../../../../build/assets/sprites/sprite_30.png")]
        private static var Sprite30:Class;

        [Embed(source="../../../../../build/assets/sprites/sprite_31.png")]
        private static var Sprite31:Class;

        [Embed(source="../../../../../build/assets/sprites/sprite_32.png")]
        private static var Sprite32:Class;

        [Embed(source="../../../../../build/assets/sprites/sprite_33.png")]
        private static var Sprite33:Class;

        [Embed(source="../../../../../build/assets/sprites/sprite_34.png")]
        private static var Sprite34:Class;

        [Embed(source="../../../../../build/assets/sprites/sprite_35.png")]
        private static var Sprite35:Class;

        [Embed(source="../../../../../build/assets/sprites/sprite_36.png")]
        private static var Sprite36:Class;

        [Embed(source="../../../../../build/assets/sprites/sprite_37.png")]
        private static var Sprite37:Class;

        [Embed(source="../../../../../build/assets/sprites/sprite_38.png")]
        private static var Sprite38:Class;

        [Embed(source="../../../../../build/assets/sprites/sprite_39.png")]
        private static var Sprite39:Class;

        [Embed(source="../../../../../build/assets/sprites/sprite_40.png")]
        private static var Sprite40:Class;

        [Embed(source="../../../../../build/assets/sprites/sprite_41.png")]
        private static var Sprite41:Class;

        [Embed(source="../../../../../build/assets/sprites/sprite_42.png")]
        private static var Sprite42:Class;

        [Embed(source="../../../../../build/assets/sprites/sprite_43.png")]
        private static var Sprite43:Class;

        [Embed(source="../../../../../build/assets/sprites/sprite_44.png")]
        private static var Sprite44:Class;

        [Embed(source="../../../../../build/assets/sprites/sprite_45.png")]
        private static var Sprite45:Class;

        private static var sprites:Array = [Sprite1,
            Sprite2,
            Sprite3,
            Sprite4,
            Sprite5,
            Sprite6,
            Sprite7,
            Sprite8,
            Sprite9,
            Sprite10,
            Sprite11,
            Sprite12,
            Sprite13,
            Sprite14,
            Sprite15,
            Sprite16,
            Sprite17,
            Sprite18,
            Sprite19,
            Sprite20,
            Sprite21,
            Sprite22,
            Sprite23,
            Sprite24,
            Sprite25,
            Sprite26,
            Sprite27,
            Sprite28,
            Sprite29,
            Sprite30,
            Sprite31,
            Sprite32,
            Sprite33,
            Sprite34,
            Sprite35,
            Sprite36,
            Sprite37,
            Sprite38,
            Sprite39,
            Sprite40,
            Sprite41,
            Sprite42,
            Sprite43,
            Sprite44,
            Sprite45];

        public static function createSprites(number:int):Array
        {
            //TODO need to add in logic to make sure there is a potion or gold in at least one round
            return ArrayUtil.shuffleArray(sprites).slice(0, number);
        }

    }
}
