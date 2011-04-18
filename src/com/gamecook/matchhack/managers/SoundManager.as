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
 *
 * This code was taken from FlxGame (https://github.com/AdamAtomic/flixel/blob/master/org/flixel/FlxGame.as) and
 * modified for this game.
 * Original Author Adam 'Atomic' Saltsman
 *
 */

package com.gamecook.matchhack.managers
{
    import com.gamecook.matchhack.sounds.MHSound;

    public class SoundManager
    {

        private var sounds:Array = [];
        private var music:MHSound;
        private var _mute:Boolean = false;
        private var _volume:Number = 1;

        public function SoundManager()
        {
        }

        /**
         * Set up and play a looping background soundtrack.
         *
         * @param    Music        The sound file you want to loop in the background.
         * @param    Volume        How loud the sound should be, from 0 to 1.
         */
        public function playMusic(Music:Class, Volume:Number = 1.0):void
        {
            if (music == null)
                music = new MHSound(this);
            else if (music.active)
                music.stop();
            music.loadEmbedded(Music, true);
            music.volume = Volume;
            music.survive = true;
            music.play();
        }

        /**
         * Creates a new sound object from an embedded <code>Class</code> object.
         *
         * @param    EmbeddedSound    The sound you want to play.
         * @param    Volume            How loud to play it (0 to 1).
         * @param    Looped            Whether or not to loop this sound.
         *
         * @return    A <code>FlxSound</code> object.
         */
        public function play(EmbeddedSound:Class, Volume:Number = 1.0, Looped:Boolean = false):MHSound
        {
            var sl:uint = sounds.length;
            for (var i:uint = 0; i < sl; i++)
                if (!(sounds[i] as MHSound).active)
                    break;
            if (sounds[i] == null)
                sounds[i] = new MHSound(this);
            var s:MHSound = sounds[i];
            s.loadEmbedded(EmbeddedSound, Looped);
            s.volume = Volume;
            s.play();
            return s;
        }

        /**
         * Set <code>mute</code> to true to turn off the sound.
         *
         * @default false
         */
        public function get mute():Boolean
        {
            return _mute;
        }

        /**
         * @private
         */
        public function set mute(Mute:Boolean):void
        {
            _mute = Mute;
            changeSounds();
        }

        /**
         * Get a number that represents the mute state that we can multiply into a sound transform.
         *
         * @return        An unsigned integer - 0 if muted, 1 if not muted.
         */
        public function getMuteValue():uint
        {
            if (_mute)
                return 0;
            else
                return 1;
        }

        /**
         * Set <code>volume</code> to a number between 0 and 1 to change the global volume.
         *
         * @default 0.5
         */
        public function get volume():Number
        {
            return _volume;
        }

        /**
         * @private
         */
        public function set volume(Volume:Number):void
        {
            _volume = Volume;
            if (_volume < 0)
                _volume = 0;
            else if (_volume > 1)
                _volume = 1;
            changeSounds();
        }

        /**
         * Called by FlxGame on state changes to stop and destroy sounds.
         *
         * @param    ForceDestroy        Kill sounds even if they're flagged <code>survive</code>.
         */
        public function destroySounds(ForceDestroy:Boolean = false):void
        {
            if (sounds == null)
                return;
            if ((music != null) && (ForceDestroy || !music.survive))
                music.destroy();
            var s:MHSound;
            var sl:uint = sounds.length;
            for (var i:uint = 0; i < sl; i++) {
                s = sounds[i] as MHSound;
                if ((s != null) && (ForceDestroy || !s.survive))
                    s.destroy();
            }
        }

        /**
         * An internal function that adjust the volume levels and the music channel after a change.
         */
        protected function changeSounds():void
        {
            if ((music != null) && music.active)
                music.updateTransform();
            var s:MHSound;
            var sl:uint = sounds.length;
            for (var i:uint = 0; i < sl; i++) {
                s = sounds[i] as MHSound;
                if ((s != null) && s.active)
                    s.updateTransform();
            }
        }

        /**
         * Internal helper, pauses all game sounds.
         */
        public function pauseSounds():void
        {
            if ((music != null) && music.active)
                music.pause();
            var s:MHSound;
            var sl:uint = sounds.length;
            for (var i:uint = 0; i < sl; i++) {
                s = sounds[i] as MHSound;
                if ((s != null) && s.active)
                    s.pause();
            }
        }

        /**
         * Internal helper, pauses all game sounds.
         */
        public function playSounds():void
        {
            if ((music != null) && music.active)
                music.play();
            var s:MHSound;
            var sl:uint = sounds.length;
            for (var i:uint = 0; i < sl; i++) {
                s = sounds[i] as MHSound;
                if ((s != null) && s.active)
                    s.play();
            }
        }
    }
}
