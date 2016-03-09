;;; xcb-xfixes.el --- X11 XFixes extension  -*- lexical-binding: t -*-

;; Copyright (C) 2015-2016 Free Software Foundation, Inc.

;; This file is part of GNU Emacs.

;; GNU Emacs is free software: you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.

;; GNU Emacs is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with GNU Emacs.  If not, see <http://www.gnu.org/licenses/>.

;;; Commentary:

;; This file was generated by 'el_client.el' from 'xfixes.xml',
;; which you can retrieve from <git://anongit.freedesktop.org/xcb/proto>.

;;; Code:

(require 'xcb-types)

(defconst xcb:xfixes:-extension-xname "XFIXES")
(defconst xcb:xfixes:-extension-name "XFixes")
(defconst xcb:xfixes:-major-version 5)
(defconst xcb:xfixes:-minor-version 0)

(require 'xcb-xproto)

(require 'xcb-render)

(require 'xcb-shape)

(defclass xcb:xfixes:QueryVersion
  (xcb:-request)
  ((~opcode :initform 0 :type xcb:-u1)
   (client-major-version :initarg :client-major-version :type xcb:CARD32)
   (client-minor-version :initarg :client-minor-version :type xcb:CARD32)))
(defclass xcb:xfixes:QueryVersion~reply
  (xcb:-reply)
  ((pad~0 :initform 1 :type xcb:-pad)
   (major-version :initarg :major-version :type xcb:CARD32)
   (minor-version :initarg :minor-version :type xcb:CARD32)
   (pad~1 :initform 16 :type xcb:-pad)))

(defconst xcb:xfixes:SaveSetMode:Insert 0)
(defconst xcb:xfixes:SaveSetMode:Delete 1)

(defconst xcb:xfixes:SaveSetTarget:Nearest 0)
(defconst xcb:xfixes:SaveSetTarget:Root 1)

(defconst xcb:xfixes:SaveSetMapping:Map 0)
(defconst xcb:xfixes:SaveSetMapping:Unmap 1)

(defclass xcb:xfixes:ChangeSaveSet
  (xcb:-request)
  ((~opcode :initform 1 :type xcb:-u1)
   (mode :initarg :mode :type xcb:BYTE)
   (target :initarg :target :type xcb:BYTE)
   (map :initarg :map :type xcb:BYTE)
   (pad~0 :initform 1 :type xcb:-pad)
   (window :initarg :window :type xcb:WINDOW)))

(defconst xcb:xfixes:SelectionEvent:SetSelectionOwner 0)
(defconst xcb:xfixes:SelectionEvent:SelectionWindowDestroy 1)
(defconst xcb:xfixes:SelectionEvent:SelectionClientClose 2)

(defconst xcb:xfixes:SelectionEventMask:SetSelectionOwner 1)
(defconst xcb:xfixes:SelectionEventMask:SelectionWindowDestroy 2)
(defconst xcb:xfixes:SelectionEventMask:SelectionClientClose 4)

(defclass xcb:xfixes:SelectionNotify
  (xcb:-event)
  ((subtype :initarg :subtype :type xcb:CARD8)
   (window :initarg :window :type xcb:WINDOW)
   (owner :initarg :owner :type xcb:WINDOW)
   (selection :initarg :selection :type xcb:ATOM)
   (timestamp :initarg :timestamp :type xcb:TIMESTAMP)
   (selection-timestamp :initarg :selection-timestamp :type xcb:TIMESTAMP)
   (pad~0 :initform 8 :type xcb:-pad)))

(defclass xcb:xfixes:SelectSelectionInput
  (xcb:-request)
  ((~opcode :initform 2 :type xcb:-u1)
   (window :initarg :window :type xcb:WINDOW)
   (selection :initarg :selection :type xcb:ATOM)
   (event-mask :initarg :event-mask :type xcb:CARD32)))

(defconst xcb:xfixes:CursorNotify:DisplayCursor 0)

(defconst xcb:xfixes:CursorNotifyMask:DisplayCursor 1)

(defclass xcb:xfixes:CursorNotify
  (xcb:-event)
  ((subtype :initarg :subtype :type xcb:CARD8)
   (window :initarg :window :type xcb:WINDOW)
   (cursor-serial :initarg :cursor-serial :type xcb:CARD32)
   (timestamp :initarg :timestamp :type xcb:TIMESTAMP)
   (name :initarg :name :type xcb:ATOM)
   (pad~0 :initform 12 :type xcb:-pad)))

(defclass xcb:xfixes:SelectCursorInput
  (xcb:-request)
  ((~opcode :initform 3 :type xcb:-u1)
   (window :initarg :window :type xcb:WINDOW)
   (event-mask :initarg :event-mask :type xcb:CARD32)))

(defclass xcb:xfixes:GetCursorImage
  (xcb:-request)
  ((~opcode :initform 4 :type xcb:-u1)))
(defclass xcb:xfixes:GetCursorImage~reply
  (xcb:-reply)
  ((pad~0 :initform 1 :type xcb:-pad)
   (x :initarg :x :type xcb:INT16)
   (y :initarg :y :type xcb:INT16)
   (width :initarg :width :type xcb:CARD16)
   (height :initarg :height :type xcb:CARD16)
   (xhot :initarg :xhot :type xcb:CARD16)
   (yhot :initarg :yhot :type xcb:CARD16)
   (cursor-serial :initarg :cursor-serial :type xcb:CARD32)
   (pad~1 :initform 8 :type xcb:-pad)
   (cursor-image :initarg :cursor-image :type xcb:-ignore)
   (cursor-image~ :initform
		  '(name cursor-image type xcb:CARD32 size
			 (*
			  (xcb:-fieldref 'width)
			  (xcb:-fieldref 'height)))
		  :type xcb:-list)))

(xcb:deftypealias 'xcb:xfixes:REGION 'xcb:-u4)

(defclass xcb:xfixes:BadRegion
  (xcb:-error)
  nil)

(defconst xcb:xfixes:Region:None 0)

(defclass xcb:xfixes:CreateRegion
  (xcb:-request)
  ((~opcode :initform 5 :type xcb:-u1)
   (region :initarg :region :type xcb:xfixes:REGION)
   (rectangles :initarg :rectangles :type xcb:-ignore)
   (rectangles~ :initform
		'(name rectangles type xcb:RECTANGLE size nil)
		:type xcb:-list)))

(defclass xcb:xfixes:CreateRegionFromBitmap
  (xcb:-request)
  ((~opcode :initform 6 :type xcb:-u1)
   (region :initarg :region :type xcb:xfixes:REGION)
   (bitmap :initarg :bitmap :type xcb:PIXMAP)))

(defclass xcb:xfixes:CreateRegionFromWindow
  (xcb:-request)
  ((~opcode :initform 7 :type xcb:-u1)
   (region :initarg :region :type xcb:xfixes:REGION)
   (window :initarg :window :type xcb:WINDOW)
   (kind :initarg :kind :type xcb:shape:KIND)
   (pad~0 :initform 3 :type xcb:-pad)))

(defclass xcb:xfixes:CreateRegionFromGC
  (xcb:-request)
  ((~opcode :initform 8 :type xcb:-u1)
   (region :initarg :region :type xcb:xfixes:REGION)
   (gc :initarg :gc :type xcb:GCONTEXT)))

(defclass xcb:xfixes:CreateRegionFromPicture
  (xcb:-request)
  ((~opcode :initform 9 :type xcb:-u1)
   (region :initarg :region :type xcb:xfixes:REGION)
   (picture :initarg :picture :type xcb:render:PICTURE)))

(defclass xcb:xfixes:DestroyRegion
  (xcb:-request)
  ((~opcode :initform 10 :type xcb:-u1)
   (region :initarg :region :type xcb:xfixes:REGION)))

(defclass xcb:xfixes:SetRegion
  (xcb:-request)
  ((~opcode :initform 11 :type xcb:-u1)
   (region :initarg :region :type xcb:xfixes:REGION)
   (rectangles :initarg :rectangles :type xcb:-ignore)
   (rectangles~ :initform
		'(name rectangles type xcb:RECTANGLE size nil)
		:type xcb:-list)))

(defclass xcb:xfixes:CopyRegion
  (xcb:-request)
  ((~opcode :initform 12 :type xcb:-u1)
   (source :initarg :source :type xcb:xfixes:REGION)
   (destination :initarg :destination :type xcb:xfixes:REGION)))

(defclass xcb:xfixes:UnionRegion
  (xcb:-request)
  ((~opcode :initform 13 :type xcb:-u1)
   (source1 :initarg :source1 :type xcb:xfixes:REGION)
   (source2 :initarg :source2 :type xcb:xfixes:REGION)
   (destination :initarg :destination :type xcb:xfixes:REGION)))

(defclass xcb:xfixes:IntersectRegion
  (xcb:-request)
  ((~opcode :initform 14 :type xcb:-u1)
   (source1 :initarg :source1 :type xcb:xfixes:REGION)
   (source2 :initarg :source2 :type xcb:xfixes:REGION)
   (destination :initarg :destination :type xcb:xfixes:REGION)))

(defclass xcb:xfixes:SubtractRegion
  (xcb:-request)
  ((~opcode :initform 15 :type xcb:-u1)
   (source1 :initarg :source1 :type xcb:xfixes:REGION)
   (source2 :initarg :source2 :type xcb:xfixes:REGION)
   (destination :initarg :destination :type xcb:xfixes:REGION)))

(defclass xcb:xfixes:InvertRegion
  (xcb:-request)
  ((~opcode :initform 16 :type xcb:-u1)
   (source :initarg :source :type xcb:xfixes:REGION)
   (bounds :initarg :bounds :type xcb:RECTANGLE)
   (destination :initarg :destination :type xcb:xfixes:REGION)))

(defclass xcb:xfixes:TranslateRegion
  (xcb:-request)
  ((~opcode :initform 17 :type xcb:-u1)
   (region :initarg :region :type xcb:xfixes:REGION)
   (dx :initarg :dx :type xcb:INT16)
   (dy :initarg :dy :type xcb:INT16)))

(defclass xcb:xfixes:RegionExtents
  (xcb:-request)
  ((~opcode :initform 18 :type xcb:-u1)
   (source :initarg :source :type xcb:xfixes:REGION)
   (destination :initarg :destination :type xcb:xfixes:REGION)))

(defclass xcb:xfixes:FetchRegion
  (xcb:-request)
  ((~opcode :initform 19 :type xcb:-u1)
   (region :initarg :region :type xcb:xfixes:REGION)))
(defclass xcb:xfixes:FetchRegion~reply
  (xcb:-reply)
  ((pad~0 :initform 1 :type xcb:-pad)
   (extents :initarg :extents :type xcb:RECTANGLE)
   (pad~1 :initform 16 :type xcb:-pad)
   (rectangles :initarg :rectangles :type xcb:-ignore)
   (rectangles~ :initform
		'(name rectangles type xcb:RECTANGLE size
		       (/
			(xcb:-fieldref 'length)
			2))
		:type xcb:-list)))

(defclass xcb:xfixes:SetGCClipRegion
  (xcb:-request)
  ((~opcode :initform 20 :type xcb:-u1)
   (gc :initarg :gc :type xcb:GCONTEXT)
   (region :initarg :region :type xcb:xfixes:REGION)
   (x-origin :initarg :x-origin :type xcb:INT16)
   (y-origin :initarg :y-origin :type xcb:INT16)))

(defclass xcb:xfixes:SetWindowShapeRegion
  (xcb:-request)
  ((~opcode :initform 21 :type xcb:-u1)
   (dest :initarg :dest :type xcb:WINDOW)
   (dest-kind :initarg :dest-kind :type xcb:shape:KIND)
   (pad~0 :initform 3 :type xcb:-pad)
   (x-offset :initarg :x-offset :type xcb:INT16)
   (y-offset :initarg :y-offset :type xcb:INT16)
   (region :initarg :region :type xcb:xfixes:REGION)))

(defclass xcb:xfixes:SetPictureClipRegion
  (xcb:-request)
  ((~opcode :initform 22 :type xcb:-u1)
   (picture :initarg :picture :type xcb:render:PICTURE)
   (region :initarg :region :type xcb:xfixes:REGION)
   (x-origin :initarg :x-origin :type xcb:INT16)
   (y-origin :initarg :y-origin :type xcb:INT16)))

(defclass xcb:xfixes:SetCursorName
  (xcb:-request)
  ((~opcode :initform 23 :type xcb:-u1)
   (cursor :initarg :cursor :type xcb:CURSOR)
   (nbytes :initarg :nbytes :type xcb:CARD16)
   (pad~0 :initform 2 :type xcb:-pad)
   (name :initarg :name :type xcb:-ignore)
   (name~ :initform
	  '(name name type xcb:char size
		 (xcb:-fieldref 'nbytes))
	  :type xcb:-list)))

(defclass xcb:xfixes:GetCursorName
  (xcb:-request)
  ((~opcode :initform 24 :type xcb:-u1)
   (cursor :initarg :cursor :type xcb:CURSOR)))
(defclass xcb:xfixes:GetCursorName~reply
  (xcb:-reply)
  ((pad~0 :initform 1 :type xcb:-pad)
   (atom :initarg :atom :type xcb:ATOM)
   (nbytes :initarg :nbytes :type xcb:CARD16)
   (pad~1 :initform 18 :type xcb:-pad)
   (name :initarg :name :type xcb:-ignore)
   (name~ :initform
	  '(name name type xcb:char size
		 (xcb:-fieldref 'nbytes))
	  :type xcb:-list)))

(defclass xcb:xfixes:GetCursorImageAndName
  (xcb:-request)
  ((~opcode :initform 25 :type xcb:-u1)))
(defclass xcb:xfixes:GetCursorImageAndName~reply
  (xcb:-reply)
  ((pad~0 :initform 1 :type xcb:-pad)
   (x :initarg :x :type xcb:INT16)
   (y :initarg :y :type xcb:INT16)
   (width :initarg :width :type xcb:CARD16)
   (height :initarg :height :type xcb:CARD16)
   (xhot :initarg :xhot :type xcb:CARD16)
   (yhot :initarg :yhot :type xcb:CARD16)
   (cursor-serial :initarg :cursor-serial :type xcb:CARD32)
   (cursor-atom :initarg :cursor-atom :type xcb:ATOM)
   (nbytes :initarg :nbytes :type xcb:CARD16)
   (pad~1 :initform 2 :type xcb:-pad)
   (cursor-image :initarg :cursor-image :type xcb:-ignore)
   (cursor-image~ :initform
		  '(name cursor-image type xcb:CARD32 size
			 (*
			  (xcb:-fieldref 'width)
			  (xcb:-fieldref 'height)))
		  :type xcb:-list)
   (pad~2 :initform 4 :type xcb:-pad-align)
   (name :initarg :name :type xcb:-ignore)
   (name~ :initform
	  '(name name type xcb:char size
		 (xcb:-fieldref 'nbytes))
	  :type xcb:-list)))

(defclass xcb:xfixes:ChangeCursor
  (xcb:-request)
  ((~opcode :initform 26 :type xcb:-u1)
   (source :initarg :source :type xcb:CURSOR)
   (destination :initarg :destination :type xcb:CURSOR)))

(defclass xcb:xfixes:ChangeCursorByName
  (xcb:-request)
  ((~opcode :initform 27 :type xcb:-u1)
   (src :initarg :src :type xcb:CURSOR)
   (nbytes :initarg :nbytes :type xcb:CARD16)
   (pad~0 :initform 2 :type xcb:-pad)
   (name :initarg :name :type xcb:-ignore)
   (name~ :initform
	  '(name name type xcb:char size
		 (xcb:-fieldref 'nbytes))
	  :type xcb:-list)))

(defclass xcb:xfixes:ExpandRegion
  (xcb:-request)
  ((~opcode :initform 28 :type xcb:-u1)
   (source :initarg :source :type xcb:xfixes:REGION)
   (destination :initarg :destination :type xcb:xfixes:REGION)
   (left :initarg :left :type xcb:CARD16)
   (right :initarg :right :type xcb:CARD16)
   (top :initarg :top :type xcb:CARD16)
   (bottom :initarg :bottom :type xcb:CARD16)))

(defclass xcb:xfixes:HideCursor
  (xcb:-request)
  ((~opcode :initform 29 :type xcb:-u1)
   (window :initarg :window :type xcb:WINDOW)))

(defclass xcb:xfixes:ShowCursor
  (xcb:-request)
  ((~opcode :initform 30 :type xcb:-u1)
   (window :initarg :window :type xcb:WINDOW)))

(xcb:deftypealias 'xcb:xfixes:BARRIER 'xcb:-u4)

(defconst xcb:xfixes:BarrierDirections:PositiveX 1)
(defconst xcb:xfixes:BarrierDirections:PositiveY 2)
(defconst xcb:xfixes:BarrierDirections:NegativeX 4)
(defconst xcb:xfixes:BarrierDirections:NegativeY 8)

(defclass xcb:xfixes:CreatePointerBarrier
  (xcb:-request)
  ((~opcode :initform 31 :type xcb:-u1)
   (barrier :initarg :barrier :type xcb:xfixes:BARRIER)
   (window :initarg :window :type xcb:WINDOW)
   (x1 :initarg :x1 :type xcb:CARD16)
   (y1 :initarg :y1 :type xcb:CARD16)
   (x2 :initarg :x2 :type xcb:CARD16)
   (y2 :initarg :y2 :type xcb:CARD16)
   (directions :initarg :directions :type xcb:CARD32)
   (pad~0 :initform 2 :type xcb:-pad)
   (num-devices :initarg :num-devices :type xcb:CARD16)
   (devices :initarg :devices :type xcb:-ignore)
   (devices~ :initform
	     '(name devices type xcb:CARD16 size
		    (xcb:-fieldref 'num-devices))
	     :type xcb:-list)))

(defclass xcb:xfixes:DeletePointerBarrier
  (xcb:-request)
  ((~opcode :initform 32 :type xcb:-u1)
   (barrier :initarg :barrier :type xcb:xfixes:BARRIER)))

(defconst xcb:xfixes:error-number-class-alist
  '((0 . xcb:xfixes:BadRegion))
  "(error-number . error-class) alist")

(defconst xcb:xfixes:event-number-class-alist
  '((0 . xcb:xfixes:SelectionNotify)
    (1 . xcb:xfixes:CursorNotify))
  "(event-number . event-class) alist")



(provide 'xcb-xfixes)

;;; xcb-xfixes.el ends here
