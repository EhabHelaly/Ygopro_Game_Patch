-- Kairem Soul
function c11511316.initial_effect(c)
	-- Place Pendulum 
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)	
	e1:SetTarget(c11511316.tg)
	e1:SetOperation(c11511316.op)
	e1:SetLabel(LOCATION_DECK)
	c:RegisterEffect(e1)
	--Place Fusion/Synchro/Xyz Pendulum
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCost(c11511316.cost)
	e2:SetTarget(c11511316.tg)
	e2:SetOperation(c11511316.op)
	e2:SetLabel(LOCATION_EXTRA)
	c:RegisterEffect(e2)

end
function c11511316.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost() end
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)
end

function c11511316.filterD(c,loc)
	if loc==LOCATION_DECK then
		return c:IsType(TYPE_PENDULUM) and c:IsSetCard(0xffc)
	else
		return c:IsType(TYPE_PENDULUM) and c:IsSetCard(0xffc) and c:IsType(TYPE_FUSION+TYPE_SYNCHRO+TYPE_XYZ)  and c:IsPosition(POS_FACEUP)
	end
end
function c11511316.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return (Duel.CheckLocation(tp,LOCATION_SZONE,6) or Duel.CheckLocation(tp,LOCATION_SZONE,7))
		and Duel.IsExistingMatchingCard(c11511316.filterD,tp,e:GetLabel(),0,1,nil,e:GetLabel()) end
end
function c11511316.op(e,tp,eg,ep,ev,re,r,rp)
	if not (Duel.CheckLocation(tp,LOCATION_SZONE,6) or Duel.CheckLocation(tp,LOCATION_SZONE,7)) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
	local g=Duel.SelectMatchingCard(tp,c11511316.filterD,tp,e:GetLabel(),0,1,1,nil,e:GetLabel())
	if g:GetCount()>0 then
	    if Duel.CheckLocation(tp,LOCATION_SZONE,6) then
	    	Duel.MoveToField(g:GetFirst(),tp,tp,LOCATION_SZONE,POS_FACEUP,6)
	    else
	    	Duel.MoveToField(g:GetFirst(),tp,tp,LOCATION_SZONE,POS_FACEUP,7)
	    end
	end
end
