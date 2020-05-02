--Vortex Wisdom
function c11511531.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcCodeFun(c,11511512,aux.FilterBoolFunction(c11511531.filterF),1,true)
	--atk def
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(LOCATION_MZONE,0)
	e1:SetCondition(c11511531.con)
	e1:SetTarget(c11511531.tg)
	e1:SetValue(c11511531.val)
	c:RegisterEffect(e1)
end
function c11511531.filterF(c)
	return c:IsFusionSetCard(0xffa) and c:IsAttribute(ATTRIBUTE_LIGHT)
end
function c11511531.con(e)
	return Duel.GetCurrentPhase()==PHASE_DAMAGE_CAL and Duel.GetAttackTarget()
end
function c11511531.tg(e,c)
	local bc=c:GetBattleTarget()
	return bc and c:IsSetCard(0xffa) and c:GetRace()==bc:GetRace() and c:GetControler()~=bc:GetControler()
end
function c11511531.val(e,c)
	return c:GetBattleTarget():GetAttack()
end
