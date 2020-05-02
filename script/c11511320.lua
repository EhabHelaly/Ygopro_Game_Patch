-- Ancient Book of Kairem
function c11511320.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	-- unaffected by cards
	local e2=Effect.CreateEffect(c)
	e2:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)	
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_IMMUNE_EFFECT)
	e2:SetRange(LOCATION_SZONE)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetTarget(c11511320.target)
	e2:SetValue(c11511320.value)
	c:RegisterEffect(e2)
	--self destroy
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCode(EFFECT_SELF_DESTROY)
	e3:SetCondition(c11511320.sdcon)
	c:RegisterEffect(e3)

end
function c11511320.value(e,re)
	return re:GetOwnerPlayer()~=e:GetHandlerPlayer()
end
function c11511320.target(e,c)
	return c:IsSetCard(0xffc) and c:IsStatus(STATUS_SUMMON_TURN+STATUS_FLIP_SUMMON_TURN+STATUS_SPSUMMON_TURN) 
end
function c11511320.filter(c)
	return c:IsSetCard(0xffc) and c:IsType(TYPE_PENDULUM) and ( c:GetSequence()==6 or c:GetSequence()==7 )
end
function c11511320.sdcon(e)
	return not Duel.IsExistingMatchingCard(c11511320.filter,e:GetHandlerPlayer(),LOCATION_SZONE,0,1,nil)
end
