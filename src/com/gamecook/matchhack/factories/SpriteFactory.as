/**
 * Created by IntelliJ IDEA.
 * User: jessefreeman
 * Date: 4/16/11
 * Time: 8:19 PM
 * To change this template use File | Settings | File Templates.
 */
package com.gamecook.matchhack.factories {
    import com.gamecook.matchhack.utils.ArrayUtil;

    public class SpriteFactory {

        [Embed(source="../../../../../build/assets/sprites/sprite_01.png")]
        private var Sprite1 : Class;

        [Embed(source="../../../../../build/assets/sprites/sprite_02.png")]
        private var Sprite2 : Class;

        [Embed(source="../../../../../build/assets/sprites/sprite_03.png")]
        private var Sprite3 : Class;

        [Embed(source="../../../../../build/assets/sprites/sprite_04.png")]
        private var Sprite4 : Class;

        [Embed(source="../../../../../build/assets/sprites/sprite_05.png")]
        private var Sprite5 : Class;

        [Embed(source="../../../../../build/assets/sprites/sprite_06.png")]
        private var Sprite6 : Class;

        [Embed(source="../../../../../build/assets/sprites/sprite_07.png")]
        private var Sprite7 : Class;

        [Embed(source="../../../../../build/assets/sprites/sprite_08.png")]
        private var Sprite8 : Class;

        [Embed(source="../../../../../build/assets/sprites/sprite_09.png")]
        private var Sprite9 : Class;

        [Embed(source="../../../../../build/assets/sprites/sprite_10.png")]
        private var Sprite10 : Class;

        [Embed(source="../../../../../build/assets/sprites/sprite_11.png")]
        private var Sprite11 : Class;

        [Embed(source="../../../../../build/assets/sprites/sprite_12.png")]
        private var Sprite12 : Class;

        [Embed(source="../../../../../build/assets/sprites/sprite_13.png")]
        private var Sprite13 : Class;

        [Embed(source="../../../../../build/assets/sprites/sprite_14.png")]
        private var Sprite14 : Class;

        [Embed(source="../../../../../build/assets/sprites/sprite_15.png")]
        private var Sprite15 : Class;

        [Embed(source="../../../../../build/assets/sprites/sprite_16.png")]
        private var Sprite16 : Class;

        [Embed(source="../../../../../build/assets/sprites/sprite_17.png")]
        private var Sprite17 : Class;

        [Embed(source="../../../../../build/assets/sprites/sprite_18.png")]
        private var Sprite18 : Class;

        [Embed(source="../../../../../build/assets/sprites/sprite_19.png")]
        private var Sprite19 : Class;

        [Embed(source="../../../../../build/assets/sprites/sprite_20.png")]
        private var Sprite20 : Class;

        [Embed(source="../../../../../build/assets/sprites/sprite_21.png")]
        private var Sprite21 : Class;

        [Embed(source="../../../../../build/assets/sprites/sprite_22.png")]
        private var Sprite22 : Class;

        [Embed(source="../../../../../build/assets/sprites/sprite_23.png")]
        private var Sprite23 : Class;

        [Embed(source="../../../../../build/assets/sprites/sprite_24.png")]
        private var Sprite24 : Class;

        [Embed(source="../../../../../build/assets/sprites/sprite_25.png")]
        private var Sprite25 : Class;

        [Embed(source="../../../../../build/assets/sprites/sprite_26.png")]
        private var Sprite26 : Class;

        [Embed(source="../../../../../build/assets/sprites/sprite_27.png")]
        private var Sprite27 : Class;

        [Embed(source="../../../../../build/assets/sprites/sprite_28.png")]
        private var Sprite28 : Class;

        [Embed(source="../../../../../build/assets/sprites/sprite_29.png")]
        private var Sprite29 : Class;

        [Embed(source="../../../../../build/assets/sprites/sprite_30.png")]
        private var Sprite30 : Class;

        [Embed(source="../../../../../build/assets/sprites/sprite_31.png")]
        private var Sprite31 : Class;

        [Embed(source="../../../../../build/assets/sprites/sprite_32.png")]
        private var Sprite32 : Class;

        [Embed(source="../../../../../build/assets/sprites/sprite_33.png")]
        private var Sprite33 : Class;

        [Embed(source="../../../../../build/assets/sprites/sprite_34.png")]
        private var Sprite34 : Class;

        [Embed(source="../../../../../build/assets/sprites/sprite_35.png")]
        private var Sprite35 : Class;

        [Embed(source="../../../../../build/assets/sprites/sprite_36.png")]
        private var Sprite36 : Class;

        [Embed(source="../../../../../build/assets/sprites/sprite_37.png")]
        private var Sprite37 : Class;

        [Embed(source="../../../../../build/assets/sprites/sprite_38.png")]
        private var Sprite38 : Class;

        [Embed(source="../../../../../build/assets/sprites/sprite_39.png")]
        private var Sprite39 : Class;

        [Embed(source="../../../../../build/assets/sprites/sprite_40.png")]
        private var Sprite40 : Class;

        [Embed(source="../../../../../build/assets/sprites/sprite_41.png")]
        private var Sprite41 : Class;

        [Embed(source="../../../../../build/assets/sprites/sprite_42.png")]
        private var Sprite42 : Class;

        [Embed(source="../../../../../build/assets/sprites/sprite_43.png")]
        private var Sprite43 : Class;

        [Embed(source="../../../../../build/assets/sprites/sprite_44.png")]
        private var Sprite44 : Class;

        [Embed(source="../../../../../build/assets/sprites/sprite_45.png")]
        private var Sprite45 : Class;

        private var sprites:Array =[Sprite1,
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

        public function SpriteFactory()
        {
        }

        public function createSprites(number:int):Array
        {
            return ArrayUtil.shuffleArray(sprites).slice(0,number);
        }

    }
}
