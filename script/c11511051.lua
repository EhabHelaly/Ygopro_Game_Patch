-- Elegantea Successor
function c11511051.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCost(c11511051.cost)
	e1:SetOperation(c11511051.activate)
	c:RegisterEffect(e1)
	Duel.AddCustomActivityCounter(11511051,ACTIVITY_SPSUMMON,c11511051.counterfilter)
end
function c11511051.counterfilter(c)
	return c:GetSummonLocation()==LOCATION_EXTRA and c:IsSetCard(0xfff)
end
function c11511051.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetTurnPlayer()==tp and Duel.GetCustomActivityCount(11511051,tp,ACTIVITY_SPSUMMON)==0 end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c11511051.splimit)
	Duel.RegisterEffect(e1,tp)
end
function c11511051.splimit(e,c,sump,sumtype,sumpos,targetp,se)
	return not c:IsLocation(LOCATION_EXTRA) or not c:IsSetCard(0xfff)
end
function c11511051.activate(e,tp,eg,ep,ev,re,r,rp)
 	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SET_SUMMON_COUNT_LIMIT)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,0)
	e1:SetValue(3)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
   local e2=Effect.CreateEffect(e:GetHandler())
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_CANNOT_SUMMON)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetTargetRange(1,0)
	e2:SetTarget(c11511051.nslimit)
	e2:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e2,tp)

end
function c11511051.nslimit(e,c,sump,sumtype,sumpos,targetp,se)
	return not c:IsSetCard(0xfff)
end
