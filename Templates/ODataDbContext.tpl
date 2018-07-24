﻿<CODEGEN_FILENAME>DbContext.dbl</CODEGEN_FILENAME>
<REQUIRES_USERTOKEN>MODELS_NAMESPACE</REQUIRES_USERTOKEN>
<REQUIRES_CODEGEN_VERSION>5.3.3</REQUIRES_CODEGEN_VERSION>
;//****************************************************************************
;//
;// Title:       ODataDbContext.tpl
;//
;// Type:        CodeGen Template
;//
;// Description: Used to create OData DbContext classes in a Harmony Core environment
;//
;// Copyright (c) 2018, Synergex International, Inc. All rights reserved.
;//
;// Redistribution and use in source and binary forms, with or without
;// modification, are permitted provided that the following conditions are met:
;//
;// * Redistributions of source code must retain the above copyright notice,
;//   this list of conditions and the following disclaimer.
;//
;// * Redistributions in binary form must reproduce the above copyright notice,
;//   this list of conditions and the following disclaimer in the documentation
;//   and/or other materials provided with the distribution.
;//
;// THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
;// AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
;// IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
;// ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE
;// LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
;// CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
;// SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
;// INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
;// CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
;// ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
;// POSSIBILITY OF SUCH DAMAGE.
;//
;;*****************************************************************************
;;
;; Title:       DbContext.dbl
;;
;; Type:        Class
;;
;; Description: OData DbContext class
;;
;;*****************************************************************************
;; WARNING
;;
;; This file was code generated. Avoid editing this file, as any changes that
;; you make will be lost of the file is re-generated.
;;
;;*****************************************************************************
;;
;; Copyright (c) 2018, Synergex International, Inc.
;; All rights reserved.
;;
;; Redistribution and use in source and binary forms, with or without
;; modification, are permitted provided that the following conditions are met:
;;
;; * Redistributions of source code must retain the above copyright notice,
;;   this list of conditions and the following disclaimer.
;;
;; * Redistributions in binary form must reproduce the above copyright notice,
;;   this list of conditions and the following disclaimer in the documentation
;;   and/or other materials provided with the distribution.
;;
;; THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
;; AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
;; IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
;; ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE
;; LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
;; CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
;; SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
;; INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
;; CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
;; ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
;; POSSIBILITY OF SUCH DAMAGE.
;;
;;*****************************************************************************

import Harmony.Core
import Harmony.Core.Context
import Microsoft.EntityFrameworkCore
import System.Linq.Expressions
import <MODELS_NAMESPACE>

namespace <NAMESPACE>

	;;; <summary>
	;;; 
	;;; </summary>
	public class DbContext extends Microsoft.EntityFrameworkCore.DbContext
	
		mDataProvider, @IDataObjectProvider

		;;; <summary>
		;;; Construct a new DbContext.
		;;; </summary>
		public method DbContext
			options, @DbContextOptions<DbContext>
			dataProvider, @IDataObjectProvider
			endparams
			parent(options)
		proc
			mDataProvider = dataProvider
		endmethod

		<STRUCTURE_LOOP>
		;;; <summary>
		;;; Exposes <StructureNoplural> data.
		;;; </summary>
		public readwrite property <StructurePlural>, @DbSet<<StructureNoplural>>

		</STRUCTURE_LOOP>
		;;; <summary>
		;;; 
		;;; </summary>
		protected override method OnConfiguring, void
			opts, @DbContextOptionsBuilder
		proc
			HarmonyDbContextOptionsExtensions.UseHarmonyDatabase(opts, mDataProvider, this)
		endmethod

		;;; <summary>
		;;; 
		;;; </summary>
		protected override method OnModelCreating, void
			parm, @ModelBuilder
		proc
			parm.Ignore(^typeof(AlphaDesc))
			parm.Ignore(^typeof(DataObjectMetadataBase))

.region "Tag filtering"

			;;This will currently only work for single field==value tags.

			<STRUCTURE_LOOP>
			<IF STRUCTURE_TAGS>
			<TAG_LOOP>
			data <structureNoplural>Param = Expression.Parameter(^typeof(<structureNoplural>))

			parm.Entity(^typeof(<structureNoplural>))
			&	.HasQueryFilter
			&	(
			&		Expression.Lambda
			&		(
			&			Expression.Block
			&			(
			&				Expression.Equal
			&				(
			&					Expression.Call
			&					(
			&						^typeof(EF),
			&						"Property",
			&						new Type[#] { ^typeof(<TAGLOOP_FIELD_CSTYPE>) },
			&						<structureNoplural>Param,
			&						Expression.Constant("<TagloopFieldName>")
			&					),
			&					Expression.Constant(<TAGLOOP_TAG_VALUE>)
			&				)
			&			),
			&			new ParameterExpression[#] { <structureNoplural>Param }
			&		)
			&	)

			</TAG_LOOP>
			</IF STRUCTURE_TAGS>
			</STRUCTURE_LOOP>
.endregion

.define INCLUDE_RELATIONS
.ifdef INCLUDE_RELATIONS
.region "Entity Relationships"

			<STRUCTURE_LOOP>
			<IF STRUCTURE_RELATIONS>
			;;--------------------------------------
			;; Relationships from <STRUCTURE_NOPLURAL>

			<RELATION_LOOP>
;// A
			<IF MANY_TO_ONE_TO_MANY>
	        ;; <STRUCTURE_NOPLURAL>.<RELATION_FROMKEY> (one) --> (one) --> (many) <RELATION_TOSTRUCTURE_NOPLURAL>.<RELATION_TOKEY>
			;;    Type          : A
			;;    From segments : <FROM_KEY_SEGMENT_LOOP><IF SEG_TYPE_FIELD><SEGMENT_NAME>(<FIELD_SPEC>)</IF SEG_TYPE_FIELD><IF SEG_TYPE_LITERAL>Literal(<SEGMENT_LITVAL>)</IF SEG_TYPE_LITERAL><,> </FROM_KEY_SEGMENT_LOOP>
			;;    To segments   : <TO_KEY_SEGMENT_LOOP><IF SEG_TYPE_FIELD><SEGMENT_NAME>(<FIELD_SPEC>)</IF SEG_TYPE_FIELD><IF SEG_TYPE_LITERAL>Literal(<SEGMENT_LITVAL>)</IF SEG_TYPE_LITERAL><,> </TO_KEY_SEGMENT_LOOP>

			parm.Entity(^typeof(<StructureNoplural>))
			&	.HasOne(^typeof(<RelationTostructureNoplural>),"REL_<RelationFromkey>")
			&	.WithMany("REL_<StructurePlural>")
			&	.HasForeignKey(<FROM_KEY_SEGMENT_LOOP><COUNTER_1_RESET>"<IF SEG_TYPE_FIELD><FieldSqlname></IF SEG_TYPE_FIELD><IF SEG_TYPE_LITERAL><COUNTER_1_INCREMENT><RelationFromkey>Literal<COUNTER_1_VALUE></IF SEG_TYPE_LITERAL>"<,></FROM_KEY_SEGMENT_LOOP>)
			&	.HasPrincipalKey(<TO_KEY_SEGMENT_LOOP><IF SEG_TYPE_FIELD>"<FieldSqlname>"</IF SEG_TYPE_FIELD><,></TO_KEY_SEGMENT_LOOP>)
			</IF MANY_TO_ONE_TO_MANY>
;// B
			<IF ONE_TO_ONE_TO_ONE>
	        ;; <STRUCTURE_NOPLURAL>.<RELATION_FROMKEY> (one) --> (one) --> (one) <RELATION_TOSTRUCTURE_NOPLURAL>.<RELATION_TOKEY>
			;;    Type          : B
			;;    From segments : <FROM_KEY_SEGMENT_LOOP><IF SEG_TYPE_FIELD><SEGMENT_NAME>(<FIELD_SPEC>)</IF SEG_TYPE_FIELD><IF SEG_TYPE_LITERAL>Literal(<SEGMENT_LITVAL>)</IF SEG_TYPE_LITERAL><,> </FROM_KEY_SEGMENT_LOOP>
			;;    To segments   : <TO_KEY_SEGMENT_LOOP><IF SEG_TYPE_FIELD><SEGMENT_NAME>(<FIELD_SPEC>)</IF SEG_TYPE_FIELD><IF SEG_TYPE_LITERAL>Literal(<SEGMENT_LITVAL>)</IF SEG_TYPE_LITERAL><,> </TO_KEY_SEGMENT_LOOP>

			parm.Entity(^typeof(<StructureNoplural>))
			&	.HasOne(^typeof(<RelationTostructureNoplural>),"REL_<RelationFromkey>")
			&	.WithOne("REL_<StructurePlural>")
			&	.HasForeignKey(<FROM_KEY_SEGMENT_LOOP><COUNTER_1_RESET>"<IF SEG_TYPE_FIELD><FieldSqlname></IF SEG_TYPE_FIELD><IF SEG_TYPE_LITERAL><COUNTER_1_INCREMENT><RelationFromkey>Literal<COUNTER_1_VALUE></IF SEG_TYPE_LITERAL>"<,></FROM_KEY_SEGMENT_LOOP>)
			&	.HasPrincipalKey(<TO_KEY_SEGMENT_LOOP><IF SEG_TYPE_FIELD>"<FieldSqlname>"</IF SEG_TYPE_FIELD><,></TO_KEY_SEGMENT_LOOP>)
			</IF ONE_TO_ONE_TO_ONE>
;// C
			<IF ONE_TO_ONE>
	        ;; <STRUCTURE_NOPLURAL>.<RELATION_FROMKEY> (one) --> (one) <RELATION_TOSTRUCTURE_NOPLURAL>.<RELATION_TOKEY>
			;;    Type          : C
			;;    From segments : <FROM_KEY_SEGMENT_LOOP><IF SEG_TYPE_FIELD><SEGMENT_NAME>(<FIELD_SPEC>)</IF SEG_TYPE_FIELD><IF SEG_TYPE_LITERAL>Literal(<SEGMENT_LITVAL>)</IF SEG_TYPE_LITERAL><,> </FROM_KEY_SEGMENT_LOOP>
			;;    To segments   : <TO_KEY_SEGMENT_LOOP><IF SEG_TYPE_FIELD><SEGMENT_NAME>(<FIELD_SPEC>)</IF SEG_TYPE_FIELD><IF SEG_TYPE_LITERAL>Literal(<SEGMENT_LITVAL>)</IF SEG_TYPE_LITERAL><,> </TO_KEY_SEGMENT_LOOP>

			parm.Entity(^typeof(<StructureNoplural>))
			&	.HasOne(^typeof(<RelationTostructureNoplural>),"REL_<RelationFromkey>")
			&	.WithOne(^null)
			&	.HasForeignKey(^typeof(<RelationTostructureNoplural>),<FROM_KEY_SEGMENT_LOOP><COUNTER_1_RESET>"<IF SEG_TYPE_FIELD><FieldSqlname></IF SEG_TYPE_FIELD><IF SEG_TYPE_LITERAL><COUNTER_1_INCREMENT><RelationFromkey>Literal<COUNTER_1_VALUE></IF SEG_TYPE_LITERAL>"<,></FROM_KEY_SEGMENT_LOOP>)
			&	.HasPrincipalKey(^typeof(<RelationTostructureNoplural>), <TO_KEY_SEGMENT_LOOP><IF SEG_TYPE_FIELD>"<FieldSqlname>"</IF SEG_TYPE_FIELD><,></TO_KEY_SEGMENT_LOOP>)
			</IF ONE_TO_ONE>
;// D
			<IF ONE_TO_MANY_TO_ONE>
	        ;; <STRUCTURE_NOPLURAL>.<RELATION_FROMKEY> (one) --> (many) --> (one) <RELATION_TOSTRUCTURE_NOPLURAL>.<RELATION_TOKEY>
			;;    Type          : D
			;;    From segments : <FROM_KEY_SEGMENT_LOOP><IF SEG_TYPE_FIELD><SEGMENT_NAME>(<FIELD_SPEC>)</IF SEG_TYPE_FIELD><IF SEG_TYPE_LITERAL>Literal(<SEGMENT_LITVAL>)</IF SEG_TYPE_LITERAL><,> </FROM_KEY_SEGMENT_LOOP>
			;;    To segments   : <TO_KEY_SEGMENT_LOOP><IF SEG_TYPE_FIELD><SEGMENT_NAME>(<FIELD_SPEC>)</IF SEG_TYPE_FIELD><IF SEG_TYPE_LITERAL>Literal(<SEGMENT_LITVAL>)</IF SEG_TYPE_LITERAL><,> </TO_KEY_SEGMENT_LOOP>

			parm.Entity(^typeof(<StructureNoplural>))
			&	.HasMany(^typeof(<RelationTostructureNoplural>),"REL_<RelationTostructurePlural>")
			&	.WithOne("REL_<RelationTokey>")
			&	.HasForeignKey(<TO_KEY_SEGMENT_LOOP><IF SEG_TYPE_FIELD>"<FieldSqlname>"</IF SEG_TYPE_FIELD><,></TO_KEY_SEGMENT_LOOP>)
			&	.HasPrincipalKey(<FROM_KEY_SEGMENT_LOOP><COUNTER_1_RESET>"<IF SEG_TYPE_FIELD><FieldSqlname></IF SEG_TYPE_FIELD><IF SEG_TYPE_LITERAL><COUNTER_1_INCREMENT><RelationFromkey>Literal<COUNTER_1_VALUE></IF SEG_TYPE_LITERAL>"<,></FROM_KEY_SEGMENT_LOOP>)
			</IF ONE_TO_MANY_TO_ONE>
;// E
			<IF ONE_TO_MANY>
	        ;; <STRUCTURE_NOPLURAL>.<RELATION_FROMKEY> (one) --> (many) <RELATION_TOSTRUCTURE_NOPLURAL>.<RELATION_TOKEY>
			;;    Type          : E
			;;    From segments : <FROM_KEY_SEGMENT_LOOP><IF SEG_TYPE_FIELD><SEGMENT_NAME>(<FIELD_SPEC>)</IF SEG_TYPE_FIELD><IF SEG_TYPE_LITERAL>Literal(<SEGMENT_LITVAL>)</IF SEG_TYPE_LITERAL><,> </FROM_KEY_SEGMENT_LOOP>
			;;    To segments   : <TO_KEY_SEGMENT_LOOP><IF SEG_TYPE_FIELD><SEGMENT_NAME>(<FIELD_SPEC>)</IF SEG_TYPE_FIELD><IF SEG_TYPE_LITERAL>Literal(<SEGMENT_LITVAL>)</IF SEG_TYPE_LITERAL><,> </TO_KEY_SEGMENT_LOOP>

			parm.Entity(^typeof(<StructureNoplural>))
			&	.HasMany(^typeof(<RelationTostructureNoplural>),"REL_<RelationFromkey>")
			&	.WithOne(^null)
			&	.HasForeignKey(^typeof(<RelationTostructureNoplural>),<FROM_KEY_SEGMENT_LOOP><COUNTER_1_RESET>"<IF SEG_TYPE_FIELD><FieldSqlname></IF SEG_TYPE_FIELD><IF SEG_TYPE_LITERAL><COUNTER_1_INCREMENT><RelationFromkey>Literal<COUNTER_1_VALUE></IF SEG_TYPE_LITERAL>"<,></FROM_KEY_SEGMENT_LOOP>)
			&	.HasPrincipalKey(^typeof(<RelationTostructureNoplural>), <TO_KEY_SEGMENT_LOOP><IF SEG_TYPE_FIELD>"<FieldSqlname>"</IF SEG_TYPE_FIELD><,></TO_KEY_SEGMENT_LOOP>)
			</IF ONE_TO_MANY>

			</RELATION_LOOP>
			</IF STRUCTURE_RELATIONS>
			</STRUCTURE_LOOP>
.endregion
.endc
			parent.OnModelCreating(parm)

		endmethod

	endclass

endnamespace