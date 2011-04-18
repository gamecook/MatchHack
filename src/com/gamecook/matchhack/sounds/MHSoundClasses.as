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

package com.gamecook.matchhack.sounds
{
    public class MHSoundClasses
    {

        [Embed(source="../../../../../build/assets/matchhacker_lib.swf", symbol="DeathTheme")]
        public static var DeathTheme:Class;

        [Embed(source="../../../../../build/assets/matchhacker_lib.swf", symbol="DungeonLooper")]
        public static var DungeonLooper:Class;

        [Embed(source="../../../../../build/assets/matchhacker_lib.swf", symbol="EnemyAttack")]
        public static var EnemyAttack:Class;

        [Embed(source="../../../../../build/assets/matchhacker_lib.swf", symbol="PotionSound")]
        public static var PotionSound:Class;

        [Embed(source="../../../../../build/assets/matchhacker_lib.swf", symbol="WalkStairsSound")]
        public static var WalkStairsSound:Class;

        [Embed(source="../../../../../build/assets/matchhacker_lib.swf", symbol="WallHit")]
        public static var WallHit:Class;

        [Embed(source="../../../../../build/assets/matchhacker_lib.swf", symbol="WinBattle")]
        public static var WinBattle:Class;

    }
}
