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



        private var lifeBar:LifeBarView;

        //public var life:int;

        public function CharacterView(name:String, life:int)
        {
            this.name = name;
            lifeBar = addChild(new LifeBarView(life)) as LifeBarView;

            createImage();
        }

        private function createImage():void
        {

        }

        public function subtractLife(value:int):void
        {
            lifeBar.subtractTotal(value)
        }

        public function addLife(value:int):void
        {
            lifeBar.addTotal(value)
        }

        public function isDead():Boolean
        {
            return (lifeBar.getTotal() <= 0);
        }

        public function getLife():int
        {
            return lifeBar.getTotal();
        }
    }
}
