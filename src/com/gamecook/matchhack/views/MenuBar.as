/**
 * Created by IntelliJ IDEA.
 * User: jessefreeman
 * Date: 5/27/11
 * Time: 4:50 PM
 * To change this template use File | Settings | File Templates.
 */
package com.gamecook.matchhack.views
{
    import com.jessefreeman.factivity.activities.IActivityManager;
    import com.jessefreeman.factivity.utils.DeviceUtil;

    import flash.display.SimpleButton;
    import flash.display.Sprite;
    import flash.events.MouseEvent;

    public class MenuBar extends Sprite
    {
        public static const EXIT_ONLY_MODE:String = "exitOnly";
        public static const IN_GAME_MODE:String = "inGameMode";

        [Embed(source="../../../../../build/assets/buttons/exit_up.png")]
        private var ExitUp:Class;

        [Embed(source="../../../../../build/assets/buttons/exit_over.png")]
        private var ExitOver:Class;

        [Embed(source="../../../../../build/assets/buttons/inventory_small_up.png")]
        private var InventoryUp:Class;

        [Embed(source="../../../../../build/assets/buttons/inventory_small_over.png")]
        private var InventoryOver:Class;

        private var fullSizeWidth:int;
        private var activity:IMenuOptions;

        public function MenuBar(mode:String, width:int, activity:IMenuOptions)
        {
            this.activity = activity;
            if(mode == IN_GAME_MODE)
                createGameButtons();
            fullSizeWidth = width;
            createBackButton();
        }

        private function createBackButton():void
        {
            if(DeviceUtil.os == DeviceUtil.ANDROID)
                return;
            var exitButton:SimpleButton = addChild(new SimpleButton(new ExitUp(), new ExitOver(), new ExitOver(), new ExitUp())) as SimpleButton;
            exitButton.name = "exitBTN";
            exitButton.x = (fullSizeWidth - exitButton.width);
            exitButton.addEventListener(MouseEvent.MOUSE_UP, onExit);

        }

        private function onExit(event:MouseEvent):void
        {
            activity.onExit();
        }

        private function createGameButtons():void
        {

        }
    }
}
