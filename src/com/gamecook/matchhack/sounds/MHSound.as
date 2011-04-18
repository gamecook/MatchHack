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
 * This code was taken from FlxGame (https://github.com/AdamAtomic/flixel/blob/master/org/flixel/FlxSound.as) and
 * modified for this game.
 * Original Author Adam 'Atomic' Saltsman
 *
 */

package com.gamecook.matchhack.sounds
{
    import com.gamecook.matchhack.managers.SoundManager;

    import flash.events.Event;
    import flash.media.Sound;
    import flash.media.SoundChannel;
    import flash.media.SoundTransform;

    public class MHSound
    {
        /**
         * Whether or not this sound should be automatically destroyed when you switch states.
         */
        public var survive:Boolean;
        /**
         * Whether the sound is currently playing or not.
         */
        public var playing:Boolean;
        /**
         * The ID3 song name.  Defaults to null.  Currently only works for streamed sounds.
         */
        public var name:String;
        /**
         * The ID3 artist name.  Defaults to null.  Currently only works for streamed sounds.
         */
        public var artist:String;

        protected var _sound:Sound;
        protected var _channel:SoundChannel;
        protected var _transform:SoundTransform;
        protected var _position:Number;
        protected var _volume:Number;
        protected var _volumeAdjust:Number;
        protected var _looped:Boolean;
        protected var _radius:Number;
        protected var _pan:Boolean;
        protected var _fadeOutTimer:Number;
        protected var _fadeOutTotal:Number;
        protected var _pauseOnFadeOut:Boolean;
        protected var _fadeInTimer:Number;
        protected var _fadeInTotal:Number;
        public var active:Boolean;
        private var manager:SoundManager;

        /**
         * The FlxSound constructor gets all the variables initialized, but NOT ready to play a sound yet.
         */
        public function MHSound(manager:SoundManager)
        {
            this.manager = manager;

            super();
            //_point2 = new FlxPoint();
            _transform = new SoundTransform();
            init();
            //fixed = true; //no movement usually
        }

        /**
         * An internal function for clearing all the variables used by sounds.
         */
        protected function init():void
        {
            _transform.pan = 0;
            _sound = null;
            _position = 0;
            _volume = 1.0;
            _volumeAdjust = 1.0;
            _looped = false;
            //_core = null;
            _radius = 0;
            _pan = false;
            _fadeOutTimer = 0;
            _fadeOutTotal = 0;
            _pauseOnFadeOut = false;
            _fadeInTimer = 0;
            _fadeInTotal = 0;
            active = false;
            /*visible = false;
             solid = false;*/
            playing = false;
            name = null;
            artist = null;
        }

        /**
         * One of two main setup functions for sounds, this function loads a sound from an embedded MP3.
         *
         * @param    EmbeddedSound    An embedded Class object representing an MP3 file.
         * @param    Looped            Whether or not this sound should loop endlessly.
         *
         * @return    This <code>FlxSound</code> instance (nice for chaining stuff together, if you're into that).
         */
        public function loadEmbedded(EmbeddedSound:Class, Looped:Boolean = false):MHSound
        {
            stop();
            init();
            _sound = new EmbeddedSound;
            //NOTE: can't pull ID3 info from embedded sound currently
            _looped = Looped;
            updateTransform();
            active = true;
            return this;
        }

        /**
         * Call this function to play the sound.
         */
        public function play():void
        {
            if (_position < 0)
                return;
            if (_looped) {
                if (_position == 0) {
                    if (_channel == null)
                        _channel = _sound.play(0, 9999, _transform);
                    if (_channel == null)
                        active = false;
                }
                else {
                    _channel = _sound.play(_position, 0, _transform);
                    if (_channel == null)
                        active = false;
                    else
                        _channel.addEventListener(Event.SOUND_COMPLETE, looped);
                }
            }
            else {
                if (_position == 0) {
                    if (_channel == null) {
                        _channel = _sound.play(0, 0, _transform);
                        if (_channel == null)
                            active = false;
                        else
                            _channel.addEventListener(Event.SOUND_COMPLETE, stopped);
                    }
                }
                else {
                    _channel = _sound.play(_position, 0, _transform);
                    if (_channel == null)
                        active = false;
                }
            }
            playing = (_channel != null);
            _position = 0;
        }

        /**
         * Call this function to pause this sound.
         */
        public function pause():void
        {
            if (_channel == null) {
                _position = -1;
                return;
            }
            _position = _channel.position;
            _channel.stop();
            if (_looped) {
                while (_position >= _sound.length)
                    _position -= _sound.length;
            }
            _channel = null;
            playing = false;
        }

        /**
         * Call this function to stop this sound.
         */
        public function stop():void
        {
            _position = 0;
            if (_channel != null) {
                _channel.stop();
                stopped();
            }
        }

        /**
         * Set <code>volume</code> to a value between 0 and 1 to change how this sound is.
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
            updateTransform();
        }

        /**
         * The basic class destructor, stops the music and removes any leftover events.
         */
        public function destroy():void
        {
            if (active)
                stop();
            manager = null;
        }

        /**
         * An internal function used to help organize and change the volume of the sound.
         */
        public function updateTransform():void
        {
            //TDOO need to look into how to get a reference of the manager in the sound.
            if (manager) {
                _transform.volume = manager.getMuteValue() * manager.volume * _volume * _volumeAdjust;
                if (_channel != null)
                    _channel.soundTransform = _transform;
            }
        }

        /**
         * An internal helper function used to help Flash resume playing a looped sound.
         *
         * @param    event        An <code>Event</code> object.
         */
        protected function looped(event:Event = null):void
        {
            if (_channel == null)
                return;
            _channel.removeEventListener(Event.SOUND_COMPLETE, looped);
            _channel = null;
            play();
        }

        /**
         * An internal helper function used to help Flash clean up and re-use finished sounds.
         *
         * @param    event        An <code>Event</code> object.
         */
        protected function stopped(event:Event = null):void
        {
            if (!_looped)
                _channel.removeEventListener(Event.SOUND_COMPLETE, stopped);
            else
                _channel.removeEventListener(Event.SOUND_COMPLETE, looped);
            _channel = null;
            active = false;
            playing = false;
        }

        /**
         * Internal event handler for ID3 info (i.e. fetching the song name).
         *
         * @param    event    An <code>Event</code> object.
         */
        protected function gotID3(event:Event = null):void
        {
            //FlxG.log("got ID3 info!");
            if (_sound.id3.songName.length > 0)
                name = _sound.id3.songName;
            if (_sound.id3.artist.length > 0)
                artist = _sound.id3.artist;
            _sound.removeEventListener(Event.ID3, gotID3);
        }
    }
}
