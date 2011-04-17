/**
 * Created by IntelliJ IDEA.
 * User: jessefreeman
 * Date: 4/16/11
 * Time: 9:53 PM
 * To change this template use File | Settings | File Templates.
 */
package com.gamecook.matchhack.views {
    import flash.display.Sprite;

    public class CharacterView extends Sprite{

        [Embed(source="../../../../../build/assets/player.png")]
        private var Player : Class;

        public var life:int;

        public function CharacterView(name:String, life:int)
        {
            this.name = name;
            this.life = life;
            createImage();
        }

        private function createImage():void
        {

        }

        public function subtractLife(value:int):void
        {
            life -= value;
        }

        public function addLife(value:int):void
        {
            life += value;
        }

        public function isDead():Boolean
        {
            return (life <= 0);
        }

        public function getLife():int
        {
            return life;
        }
    }
}
