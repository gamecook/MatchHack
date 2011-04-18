/**
 * Created by IntelliJ IDEA.
 * User: jfreeman
 * Date: 3/18/11
 * Time: 3:58 PM
 * To change this template use File | Settings | File Templates.
 */
package com.gamecook.matchhack.states
{
    import com.gamecook.tilecrusader.enum.ApplicationShareObjects;

    import flash.geom.Point;

    public class ActiveGameState extends AbstractStateObject
    {
        public function ActiveGameState()
        {
            super(this, ApplicationShareObjects.ACTIVE_GAME)
        }

        public function get player():Object
        {
            return _dataObject.player;
        }

        public function set player(value:Object):void
        {
            _dataObject.player = value;
        }

        public function get tileInstanceManager():Object
        {
            return _dataObject.tileInstanceManager;
        }

        public function set tileInstanceManager(value:Object):void
        {
            _dataObject.tileInstanceManager = value;
        }

        public function get mapSelection():Object
        {
            return _dataObject.mapSelection;
        }

        public function set mapSelection(value:Object):void
        {
            _dataObject.mapSelection = value;
        }

        public function get startPositionPoint():Point
        {
            var obj:Object = _dataObject.startPosition;
            return new Point(obj.x, obj.y);
        }

        public function set startPositionPoint(value:Point):void
        {
            _dataObject.startPosition = {x:value.x, y:value.y};
        }

        public function set startPosition(value:Object):void
        {
            _dataObject.startPosition = value;
        }

        public function set map(value:Object):void
        {
            _dataObject.map = value;
        }

        public function get map():Object
        {
            return _dataObject.map;
        }

        public function get size():int
        {
            return _dataObject.size;
        }

        public function set size(value:int):void
        {
            _dataObject.size = value;
        }

        public function set startMessage(startMessage:String):void
        {
            _dataObject.startMessage = startMessage;
        }

        public function get startMessage():String
        {
            return _dataObject.startMessage;
        }

        public function set cashPool(cashPool:int):void
        {
            _dataObject.cashPool = cashPool;
        }

        public function get cashPool():int
        {
            return _dataObject.cashPool;
        }

        public function set cashRange(cashRange:int):void
        {
            _dataObject.cashRange = cashRange;
        }

        public function get cashRange():int
        {
            return _dataObject.cashRange;
        }

        public function set treasurePool(treasurePool:Array):void
        {
            _dataObject.treasurePool = treasurePool;
        }

        public function get treasurePool():Array
        {
            return _dataObject.treasurePool;
        }

        public function get gameType():String
        {
            return _dataObject.gameType;
        }

        public function set gameType(value:String):void
        {
            _dataObject.gameType = value;
        }

        public function set activeGame(activeGame:Boolean):void
        {
            _dataObject.activeGame = activeGame;
        }

        public function get activeGame():Boolean
        {
            return _dataObject.activeGame
        }

        public function set darkness(darkness:String):void
        {
            _dataObject.darkness = darkness;
        }

        public function get darkness():String
        {
            return _dataObject.darkness;
        }

        public function get showMonsters():Boolean
        {
            return _dataObject.showMonsters;
        }

        public function set showMonsters(value:Boolean):void
        {
            _dataObject.showMonsters = value;

        }

        public function get monstersDropTreasure():Boolean
        {
            return _dataObject.monstersDropTreasure;
        }

        public function set monstersDropTreasure(value:Boolean):void
        {
            _dataObject.monstersDropTreasure = value;
        }

        public function clearMapData():void
        {
            delete _dataObject.tileInstanceManager;
            delete _dataObject.mapSelection;
            delete _dataObject.startPosition;
            delete _dataObject.map;
            delete _dataObject.size;
            delete _dataObject.startMessage;
            delete _dataObject.cashPool;
            delete _dataObject.cashRange;
            delete _dataObject.treasurePool;
            delete _dataObject.gameType;
            delete _dataObject.darkness;
            delete _dataObject.showMonsters;
            delete _dataObject.monstersDropTreasure;
        }

        public function set lastActivity(lastActivity:String):void
        {
            _dataObject.lastActivity = lastActivity;
        }
    }
}
