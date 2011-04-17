/**
 * Created by IntelliJ IDEA.
 * User: jessefreeman
 * Date: 4/17/11
 * Time: 1:32 PM
 * To change this template use File | Settings | File Templates.
 */
package com.gamecook.matchhack.factories {
    import com.gamecook.matchhack.utils.ArrayUtil;

    import flash.display.Bitmap;

    public class CharacterFactory {

        [Embed(source="../../../../../build/assets/characters/player_01.png")]
        private static var Player1 : Class;

        [Embed(source="../../../../../build/assets/characters/monster_01.png")]
        private static var Monster1 : Class;

        [Embed(source="../../../../../build/assets/characters/monster_02.png")]
        private static var Monster2 : Class;

        [Embed(source="../../../../../build/assets/characters/monster_03.png")]
        private static var Monster3 : Class;

        [Embed(source="../../../../../build/assets/characters/monster_04.png")]
        private static var Monster4 : Class;

        [Embed(source="../../../../../build/assets/characters/monster_05.png")]
        private static var Monster5 : Class;

        [Embed(source="../../../../../build/assets/characters/monster_06.png")]
        private static var Monster6 : Class;

        [Embed(source="../../../../../build/assets/characters/monster_07.png")]
        private static var Monster7 : Class;

        [Embed(source="../../../../../build/assets/characters/monster_08.png")]
        private static var Monster8 : Class;

        [Embed(source="../../../../../build/assets/characters/monster_09.png")]
        private static var Monster9 : Class;

        private static var sprites:Array =[Monster1,
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
            var classInstance:Class = ArrayUtil.shuffleArray(sprites).slice(0,1)[0] as Class;
            return new classInstance() as Bitmap;
        }

        public static function createPlayerBitmap():Bitmap
        {
            return new Player1() as Bitmap;
        }
    }
}
