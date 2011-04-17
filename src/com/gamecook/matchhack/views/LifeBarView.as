/**
 * Created by IntelliJ IDEA.
 * User: jessefreeman
 * Date: 4/17/11
 * Time: 12:51 PM
 * To change this template use File | Settings | File Templates.
 */
package com.gamecook.matchhack.views {
    import flash.display.Bitmap;
    import flash.display.Shape;
    import flash.display.Sprite;

    import spark.primitives.Graphic;

    public class LifeBarView extends Sprite{

        [Embed(source="../../../../../build/assets/life_bar_bg.png")]
        private var LifeBarBackground : Class;
        private var total:int;
        private var initialTotal:int;
        private var backgroundImage:Bitmap;
        private var lifeBar:Shape;

        public function LifeBarView(total:int)
        {
            this.total = initialTotal = total;

            backgroundImage = addChild(new LifeBarBackground) as Bitmap;

            //Draw Lifebar
            var padding:int = 2;

            lifeBar = addChild(new Shape()) as Shape;
            lifeBar.graphics.beginFill(0xFF0000);
            lifeBar.graphics.drawRect(0, 0, backgroundImage.width - (padding*2), backgroundImage.height - (padding*2));
            lifeBar.graphics.endFill();
            lifeBar.x = lifeBar.y = padding;

            updateLifeBar();
        }

        public function subtractTotal(value:int):void
        {
            total -= value;
            updateLifeBar();
        }

        public function addTotal(value:int):void
        {
            total += value;
            updateLifeBar();
        }

        public function getTotal():int
        {
            return total;
        }

        private function updateLifeBar():void
        {
            lifeBar.scaleY = 1 - total/initialTotal;
        }
    }
}
