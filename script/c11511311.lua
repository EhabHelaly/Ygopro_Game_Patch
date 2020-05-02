-- Kairem Xi
function c11511311.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	--synchro summon
	aux.AddSynchroProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0xffc),1,1,aux.NonTuner(Card.IsSetCard,0xffc),1,1)
	c:EnableReviveLimit()

	-- unaffected by card (Synchro Summon)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_IMMUNE_EFFECT)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(c11511311.conSP)
	e1:SetValue(c11511311.efilter)
	e1:SetLabel(SUMMON_TYPE_SYNCHRO)
	c:RegisterEffect(e1)
	-- cant battle destroy (Pendulum Summon)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e2:SetCondition(c11511311.conSP)
	e2:SetValue(1)
	e2:SetLabel(SUMMON_TYPE_PENDULUM)
	c:RegisterEffect(e2)
	--Battle indestructable (Pendulum Effect)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetRange(LOCATION_PZONE)
	e3:SetCode(EFFECT_INDESTRUCTABLE_COUNT)
	e3:SetTargetRange(LOCATION_MZONE,0)
	e3:SetTarget(c11511311.tg3)
	e3:SetValue(c11511311.val3)
	e3:SetCountLimit(1)
	c:RegisterEffect(e3)
end
function c11511311.tg3(e,c)
	return c:IsSetCard(0xffc)
end
function c11511311.val3(e,re,r,rp)
	return bit.band(r,REASON_BATTLE+REASON_EFFECT)~=0
end
function c11511311.conSP(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetSummonType()==e:GetLabel()
end
function c11511311.efilter(e,te)
	return te:GetOwnerPlayer()~=e:GetHandlerPlayer()
end
